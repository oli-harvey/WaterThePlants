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

    @NSManaged public var due: Date?
    @NSManaged public var dueEveryAmount: Int64
    @NSManaged public var dueEveryValue: String?
    @NSManaged public var lastComplete: Date?
    @NSManaged public var name: String?
    @NSManaged public var repetitions: Int64
    @NSManaged public var repetitionStatusValue: Int32
    @NSManaged public var taskStatusValue: String?
    @NSManaged public var timesCompleted: Int64
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
}

extension Task {
    var timeElapsed: TimeInterval {
        Date().timeIntervalSince(lastComplete ?? Date())
    }
    var timeRemaining: TimeInterval {
        due?.timeIntervalSince(Date()) ?? TimeInterval(100)
    }
    var totalTime: TimeInterval {
        due?.timeIntervalSince(lastComplete ?? Date()) ?? TimeInterval(100)
    }
    var percentComplete: CGFloat {
        CGFloat(timeElapsed / totalTime)
    }
    var colour: Color {
        Color(red: Double(percentComplete), green: Double(1 - percentComplete), blue: 0)
    }
    var completionDescTime: String {
        switch taskStatus {
//        case .due:
//            return "Due"
//        case .cancelled:
//            return "Cancelled"
        case .done:
            return "Done"
        default:
            return timeRemaining.format()
        }
    }
    var lastCompleteTimeSince: TimeInterval {
        Date().timeIntervalSince(lastComplete ?? Date())
    }

}

extension Task {
    func taskDone() {
        timesCompleted += 1
        lastComplete = Date()
        if timesCompleted >= repetitions {
            taskStatus = .done
        } else {
            taskStatus = .running
        }
    }
//    func setToCancelled() {
//        taskStatus = .cancelled
//    }
}

extension Task {
    func scheduleNotification() {
        let center = UNUserNotificationCenter.current()

            let addRequest = {
                let content = UNMutableNotificationContent()
                content.title = "Task due: \(self.name ?? "Unknown Task")"
                content.subtitle = "at: \(self.due?.timeString() ?? "Unknown Time")"
                content.sound = UNNotificationSound.default
                
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: self.timeRemaining, repeats: false)


                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
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
}
