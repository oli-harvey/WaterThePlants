import Combine
import SwiftUI

struct EditView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    
    @State var taskViewData: TaskViewData

    @State private var showingError = false
    @State private var error: TaskError? = nil
    @State private var customCompletionDate = false


   
    var body: some View {
        NavigationView {
            Form {
                // name
                Section(header: Text("Task") ) {
                    TextField("Name", text: $taskViewData.name)
                }
                // due
                Section(header: Text("Due"),
                        footer: Text("Due at \(taskViewData.dueDate.timeString()) \(taskViewData.dueDate.dateString())")) {
                    
                    Picker(selection: $taskViewData.dueType, label: Text("Due On date, At a time or after a period of time")) {
                        ForEach(DueType.allCases, id: \.self) { type in
                            Text(type.rawValue)
                        }
                    }
                    .onChange(of: taskViewData.dueType, perform: { dueType in
                        if dueType == .on {
                            // set to end of day so you have all day to do the task if needed and avoids due date in past error
                            let cal = Calendar(identifier: .gregorian)
                            let endOfDueDate = cal.date(bySettingHour: 23, minute: 59, second: 59, of: taskViewData.dueDate) ?? Date()
                            taskViewData.dueDate = endOfDueDate
                        } else {
                            taskViewData.dueDate = Date()
                        }
                    })
                        .pickerStyle(SegmentedPickerStyle())
                    if taskViewData.dueType == .at {
                        DatePicker("Due at", selection: $taskViewData.dueDate)
                    } else if taskViewData.dueType == .after {
                        Picker(selection: $taskViewData.dueTimePart, label: Text("Due After")) {
                                ForEach(TimePart.allCases, id: \.self) { timePart in
                                    Text(timePart.rawValue + "\(taskViewData.dueTimePartAmount > 1 ? "s" : "")")
                                }
                            }
                        Picker(selection: $taskViewData.dueTimePartAmount, label: Text("")) {
                            ForEach(1..<taskViewData.dueTimePart.max(), id: \.self) {
                                    Text(("\($0)"))
                                }
                            }

                    } else {
                        DatePicker("Due on", selection: $taskViewData.dueDate, displayedComponents: .date)
                    }
                } // end due
                
                // Repeat
                Section(header: Text("Repeat")) {
                    Toggle(isOn: $taskViewData.repeats) {
                        Text("Repeats")
                    }
                    if taskViewData.repeats {
                        Picker(selection: $taskViewData.dueEvery, label: Text("Due Every")) {
                            ForEach(TimePart.allCases, id: \.self) { timePart in
                                Text(timePart.rawValue  + "\(taskViewData.dueEveryAmount > 1 ? "s" : "")")
                            }
                        }
                        Picker(selection: $taskViewData.dueEveryAmount, label: Text("Due Every")) {
                            ForEach(1..<taskViewData.dueEvery.max(), id: \.self) {
                                Text(("\($0)"))
                            }
                        }
                        Toggle(isOn: $taskViewData.repeatsForever) {
                            Text("Forever")
                        }
                        if !taskViewData.repeatsForever {
                            Picker(selection: $taskViewData.repetitions, label: Text("Times")) {
                                ForEach(1...100, id: \.self) {
                                    Text(("\($0)"))
                                }
                            }
                        }
                    }
                }
                
                // last completed
                Section(header: Text("Last Completed"),
                        footer: Text("Counting from \( customCompletionDate ? "\(taskViewData.completionDate.timeString()) \(taskViewData.completionDate.dateString())" : "now")")) {
                    Toggle(isOn: $customCompletionDate) {
                        Text("Completed before")
                    }
                    if customCompletionDate {
                        DatePicker("On", selection: $taskViewData.completionDate)
                        
                    }
                }// end last completed
                .alert(isPresented: $showingError) {
                    Alert(title: Text(error?.errorTitle ?? "Dont know what you did!"), message: Text(error?.localizedDescription ?? "Unknown Error"), dismissButton: .default(Text("Got it!")))
                }
                .onAppear{
                    print("printing from editview")
                    print(taskViewData.name)
                }
                
            } // Form
            .navigationBarTitle(Text("Edit Task"), displayMode: .inline)
            .navigationBarItems(
                leading:
                    Button("Cancel") {
                        self.presentationMode.wrappedValue.dismiss()
                    },
                trailing:
                    Button(taskViewData.editting ? "Edit" : "Add") {
                        do {
                            try saveTask()
                            self.presentationMode.wrappedValue.dismiss()
                        } catch let error as TaskError {
                            showingError = true
                            self.error = error
                        } catch {
                            print(error.localizedDescription)
                        }
                        
                    }
            )

        } // NavigationView

        
    } // body
    
    // init from coredata tasl
    
    func dueTimein(_ timePart: TimePart, amount: Int) -> TimeInterval {
        var time = TimeInterval()
        time += timePart.seconds() * Double(amount)
        return time
    }
    
    // func to save to coredata
    
    public func saveTask() throws {

        if taskViewData.repeatsForever {
            taskViewData.repetitionStatus = .forever
            taskViewData.repetitions = 1000
        } else if taskViewData.repetitions > 0 {
            taskViewData.repetitionStatus = .times
            } else {
                taskViewData.repetitionStatus = .none
            }
            
        if taskViewData.dueType == .after {
            taskViewData.dueDate = Date().addingTimeInterval(dueTimein(taskViewData.dueTimePart, amount: taskViewData.dueTimePartAmount))
        } else if taskViewData.dueType == .on {
            // set to end of day so you have all day to do the task if needed and avoids due date in past error
            let cal = Calendar(identifier: .gregorian)
            let endOfDueDate = cal.date(bySettingHour: 23, minute: 59, second: 59, of: taskViewData.dueDate) ?? Date()
            taskViewData.dueDate = endOfDueDate
        }
        guard taskViewData.name != "" else { throw TaskError.nameEmpty }
        guard taskViewData.dueDate > Date() else { throw TaskError.dueDateInPast }
        guard taskViewData.completionDate < Date() else { throw TaskError.lastCompleteInFuture}
        
        let newTask = Task(context: viewContext)
        newTask.name = taskViewData.name
        newTask.dueDate = taskViewData.dueDate
        newTask.completionDate = taskViewData.completionDate
        newTask.repetitions = Int64(taskViewData.repetitions)
        newTask.repetitionStatus = taskViewData.repetitionStatus
        newTask.dueEvery = taskViewData.dueEvery
        newTask.dueEveryAmount = Int64(taskViewData.dueEveryAmount)
        newTask.dueType = taskViewData.dueType
        newTask.lastCompletions = [Bool]()
        newTask.timesCompleted = Int64(taskViewData.timesCompleted)
        

        
        print(newTask)
        // if editting we actually created a duplicate so delete the original
        if taskViewData.editting {
            if let task = taskViewData.task {
                viewContext.delete(task)
            }
        }
        // now try and save
        do {
            try viewContext.save()
            newTask.scheduleNotification()
        } catch {
            print("error during save context")
            print(error.localizedDescription)
        }
    }
    
}

