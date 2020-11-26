//import SwiftUI
//
//class TaskViewData: Identifiable, ObservableObject {
//
//    @Published var name: String
//    @Published var dueType: DueType
//    @Published var repetitions: Int
//    @Published var dueDate: Date
//    @Published var repeats: Bool
//    @Published var repeatsForever: Bool
//    @Published var repetitionStatus: RepetitionStatus
//    @Published var dueEvery: TimePart
//    @Published var dueEveryAmount: Int
//    @Published var completionDate: Date
//    @Published var dueTimePart: TimePart
//    @Published var dueTimePartAmount: Int
//
//    // default task view data
//    init() {
//        self.name = ""
//        self.dueType = .at
//        self.repetitions = 1
//        self.dueDate = Date()
//        self.repeats = false
//        self.repeatsForever = false
//        self.repetitionStatus = .none
//        self.dueEvery = .day
//        self.dueEveryAmount = 1
//        self.completionDate = Date()
//
//        self.dueTimePart = .day
//        self.dueTimePartAmount = 1
//    }
//
//    // init from task
//    init(task: Task) {
//        self.name = task.name ?? ""
//        self.dueType = task.dueType
//        self.repetitions = Int(task.repetitions)
//        self.dueDate = task.dueDate ?? Date()
//        self.repeats = task.repetitionStatus != .none
//        self.repeatsForever = task.repetitionStatus == .forever
//        self.repetitionStatus = task.repetitionStatus
//        self.dueEvery = task.dueEvery
//        self.dueEveryAmount = Int(task.dueEveryAmount)
//        self.completionDate = task.completionDate ?? Date()
//
//        self.dueTimePart = .day
//        self.dueTimePartAmount = 1
//
//        print(name)
//    }
//
//}
//

import SwiftUI

struct TaskViewData {
    
  //  var taskID: UUID
    var name: String
    var dueType: DueType
    var repetitions: Int
    var dueDate: Date
    var repeats: Bool
    var repeatsForever: Bool
    var repetitionStatus: RepetitionStatus
    var dueEvery: TimePart
    var dueEveryAmount: Int
    var completionDate: Date
    var dueTimePart: TimePart
    var dueTimePartAmount: Int
    
    var editting: Bool
    var task: Task?
    
    // default task view data
    init() {
 //       self.taskID = UUID()
        self.name = ""
        self.dueType = .at
        self.repetitions = 1
        self.dueDate = Date()
        self.repeats = false
        self.repeatsForever = false
        self.repetitionStatus = .none
        self.dueEvery = .day
        self.dueEveryAmount = 1
        self.completionDate = Date()
        
        self.dueTimePart = .day
        self.dueTimePartAmount = 1
        
        self.editting = false
        self.task = nil
    }
    
    // init from task
    init(task: Task) {
//        self.taskID = task.taskID
        self.name = task.name ?? ""
        self.dueType = task.dueType
        self.repetitions = Int(task.repetitions)
        self.dueDate = task.dueDate ?? Date()
        self.repeats = task.repetitionStatus != .none
        self.repeatsForever = task.repetitionStatus == .forever
        self.repetitionStatus = task.repetitionStatus
        self.dueEvery = task.dueEvery
        self.dueEveryAmount = Int(task.dueEveryAmount)
        self.completionDate = task.completionDate ?? Date()

        self.dueTimePart = .day
        self.dueTimePartAmount = 1
        
        self.editting = true
        self.task = task
    }
    
}


