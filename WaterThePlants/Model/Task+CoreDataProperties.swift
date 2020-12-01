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
        Color(red: Double(percentComplete), green: Double(1 - percentComplete), blue: 0)
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
    var tickUnit: TimePart {
        let min = 6.0
        switch totalTime {
        case ..<0:
            return .min
        case 0..<TimePart.hour.seconds() * min:
            return .min
        case 0..<TimePart.day.seconds() * min:
            return .hour
        case 0..<TimePart.week.seconds() * min:
            return .day
        case 0..<TimePart.month.seconds() * min:
            return .week
        case 0..<TimePart.year.seconds() * min:
            return .month
        default:
            return .year
        }
    }
    
    var tickNumber: Int {
        print(name)
        print("elapsed: \(timeElapsed)")
        print("pct complete: \(percentComplete)")
        print("totalTime: \(totalTime)")
        print("tickunit secs: \(tickUnit.seconds())")
        print(Int(totalTime / tickUnit.seconds()))
        print(tickUnit)
        return Int(totalTime / tickUnit.seconds())
    }

}

extension Task {
    func taskDone() {
        timesCompleted += 1
        addCompletion(completed: true)
        updateRepetitions()
    }
    func skipDone() {
        timesSkipped += 1
        addCompletion(completed: false)
        updateRepetitions()
    }
    func updateRepetitions() {
        completionDate = Date()
        
        if timesCompleted + timesSkipped >= repetitions && repetitionStatus != .forever  {
            taskStatus = .done
        } else if repetitionStatus == .none {
            taskStatus = .done
        } else {
            taskStatus = .running
   //         let duration = dueDate! - completionDate!
//            dueDate = dueDate?.addingTimeInterval(duration)
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
