//
//  Task+CoreDataProperties.swift
//  WaterThePlants
//
//  Created by Oliver Harvey on 07/11/2020.
//
//

import Foundation
import CoreData
import SwiftUI
import UserNotifications

extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }
    @NSManaged public var dueDate: Date?
    @NSManaged public var dueTypeValue: String?
    @NSManaged public var dueEveryAmount: Int64
    @NSManaged public var dueEveryValue: String?
    @NSManaged public var completionDate: Date?
    @NSManaged public var name: String?
    @NSManaged public var repetitions: Int64
    @NSManaged public var repetitionStatusValue: Int32
    @NSManaged public var taskStatusValue: String?
    @NSManaged public var timesCompleted: Int64
    @NSManaged public var timesSkipped: Int64
    @NSManaged public var lastCompletionsValue: String
    @NSManaged public var notificationID: String?
}

extension Task : Identifiable {
}

extension Task {
    var repetitionStatus: RepetitionStatus {
        get {
            return RepetitionStatus(rawValue: self.repetitionStatusValue)!
        }
        
        set {
            self.repetitionStatusValue = newValue.rawValue
        }
    }
    var dueEvery: TimePart {
        get {
            return TimePart(rawValue: self.dueEveryValue ?? "Day")!
        }
        set {
            self.dueEveryValue = newValue.rawValue
        }
    }
    var taskStatus: TaskStatus {
        get {
            return TaskStatus(rawValue: self.taskStatusValue ?? "Running") ?? TaskStatus.running
        }
        set {
            self.taskStatusValue = newValue.rawValue
        }
    }
    var dueType: DueType {
        get {
            return DueType(rawValue: self.dueTypeValue ?? "At") ?? DueType.at
        }
        set {
            print("setting duetype to \(newValue.rawValue)")
            self.dueTypeValue = newValue.rawValue
        }
    }
    
    var lastCompletions: [Bool] {
        get {
            var lastCompletions = [Bool]()
            for char in lastCompletionsValue {
                char == "1" ? lastCompletions.append(true) : lastCompletions.append(false)
            }
            return lastCompletions
        }
        set {
            var lastCompletionsString = ""
            for val in newValue {
                val ? lastCompletionsString.append("1") : lastCompletionsString.append("0")
            }
            self.lastCompletionsValue = lastCompletionsString
        }
    }
    
    var repsLeft: String {
        if repetitionStatus == .forever {
           return "inf"
        } else if repetitionStatus == .times {
            return String(repetitions - timesCompleted - timesSkipped)
        } else {
            return "one off"
        }
    }
}

extension Task {
    var timeElapsed: TimeInterval {
        Date().timeIntervalSince(completionDate ?? Date())
    }
    var timeRemaining: TimeInterval {
        dueDate?.timeIntervalSince(Date()) ?? TimeInterval(100)
    }
    var totalTime: TimeInterval {
        dueDate?.timeIntervalSince(completionDate ?? Date()) ?? TimeInterval(100)
    }
    var percentComplete: CGFloat {
        CGFloat(timeElapsed / totalTime)
    }
    var colour: Color {
        let colors: [UIColor] = [.green, .orange, .red]
        return Color(colors.intermediate(percentage: percentComplete))
        //Color(red: Double(percentComplete), green: Double(1 - percentComplete), blue: 0)
    }
    var completionDescTime: String {
        switch taskStatus {
        case .done:
            return "Done"
        default:
            return timeRemaining.format()
        }
    }
    var lastCompleteTimeSince: TimeInterval {
        Date().timeIntervalSince(completionDate ?? Date())
    }
}

extension Task {
    func taskDone() {
        timesCompleted += 1
        addCompletion(completed: true)
        let wait = beingEditted ? 0.5 : 0.0
        DispatchQueue.main.asyncAfter(deadline: .now() + wait) {
            self.updateRepetitions()
        }
        
    }
    func skipDone() {
        timesSkipped += 1
        addCompletion(completed: false)
        let wait = beingEditted ? 0.5 : 0.0
        DispatchQueue.main.asyncAfter(deadline: .now() + wait) {
            self.updateRepetitions()
        }
    }
    func updateRepetitions() {
        completionDate = Date()
        cancelNotification()
        if timesCompleted + timesSkipped >= repetitions && repetitionStatus != .forever  {
            taskStatus = .done
        } else if repetitionStatus == .none {
            taskStatus = .done
        } else {
            taskStatus = .running
            let newDue = dueEvery.seconds() * Double(dueEveryAmount)
            dueDate = completionDate?.addingTimeInterval(newDue)
            scheduleNotification()
        }
    }
    func addCompletion(completed: Bool) {
        lastCompletions.append(completed)
        if lastCompletions.count > 5 {
            lastCompletions.removeFirst()
        }
    }
}

extension Task {
    func scheduleNotification() {
        let center = UNUserNotificationCenter.current()

            let addRequest = {
                self.cancelNotification()
                let content = UNMutableNotificationContent()
                content.title = "Task due: \(self.name ?? "Unknown Task")"
                content.subtitle = "at: \(self.dueDate?.timeString() ?? "Unknown Time")"
                content.sound = UNNotificationSound.default
                
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: self.timeRemaining, repeats: false)


                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                self.notificationID = request.identifier
                center.add(request)
            }
        
        center.getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized {
                addRequest()
            } else {
                center.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                    if success {
                        addRequest()
                    } else {
                        print("D'oh")
                    }
                }
            }
        }

    }
    
    func cancelNotification() {
        let center = UNUserNotificationCenter.current()
        guard let id = self.notificationID else { return }
        center.removeDeliveredNotifications(withIdentifiers: [id])
        center.removePendingNotificationRequests(withIdentifiers: [id])
    }
}

extension Task {
    var dueWithinTimeParts: [TimePart] {
        let calendar = Calendar.current
        //Get today's beginning & end
        let dayStart = calendar.startOfDay(for: Date()) // eg. 2016-10-10 00:00:00
        let dayEnd = calendar.date(byAdding: .day, value: 1, to: dayStart)!
        let weekEnd = calendar.date(byAdding: .day , value: 7, to: dayStart)!
        let month = calendar.component(.month, from: Date())
        let year = calendar.component(.year, from: Date())
        
        var dueWithinTimeParts = [TimePart]()
        
        if let dueDate = dueDate {
            if dueDate <= dayEnd {
                dueWithinTimeParts.append(.day)
            }
            if dueDate <= weekEnd {
                dueWithinTimeParts.append(.week)
            }
            if month == calendar.component(.month, from: dueDate) {
                dueWithinTimeParts.append(.month)
            }
            if year == calendar.component(.year, from: dueDate) {
                dueWithinTimeParts.append(.year)
            }
        }
        return dueWithinTimeParts
    }
}


