import Combine
import SwiftUI

struct TaskDetailView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    
    @State private var name: String = ""

    @State private var dueType: DueType = .after
    @State private var repetitions: Int64 = 1
    @State private var dueDate = Date()
    
    @State private var dueTimePart: TimePart = .day
    @State private var dueTimePartAmount: Int = 1
    
    @State private var repeats: Bool = false
    @State private var repeatsForever: Bool = true
    @State private var repetitionStatus: RepetitionStatus = .none
    @State private var dueEvery: TimePart = .day
    @State private var dueEveryAmount: Int64 = 1

    
    @State private var customCompletionDate = false
    @State private var completetionDate = Date()

    @State private var showingError = false
    @State private var error: TaskError? = nil
    @State private var startingFrom = Date()
   
    var body: some View {
        NavigationView {
            Form {
                // name
                Section(header: Text("Task") ) {
                   TextField("Name", text: $name)
                }
                // due
                Section(header: Text("Due"),
                        footer: Text("Due at \(dueDate.timeString()) \(dueDate.dateString())")) {
                    
                    Picker(selection: $dueType, label: Text("Due On date, At a time or after a period of time")) {
                        ForEach(DueType.allCases, id: \.self) { type in
                            Text(type.rawValue)
                        }
                    }
                        .pickerStyle(SegmentedPickerStyle())
                    if dueType == .at {
                       DatePicker("Due at", selection: $dueDate)
                    } else if dueType == .after {
                            Picker(selection: $dueTimePart, label: Text("Due After")) {
                                ForEach(TimePart.allCases, id: \.self) { timePart in
                                    Text(timePart.rawValue + "\(dueTimePartAmount > 1 ? "s" : "")")
                                }
                            }
                            Picker(selection: $dueTimePartAmount, label: Text("")) {
                                ForEach(1..<dueTimePart.max(), id: \.self) {
                                    Text(("\($0)"))
                                }
                            }

                    } else {
                        DatePicker("Due on", selection: $dueDate, displayedComponents: .date)
                    }
                } // end due
                
                // Repeat
                Section(header: Text("Repeat")) {
                    Toggle(isOn: $repeats) {
                        Text("Repeats")
                    }
                    if repeats {
                        Picker(selection: $dueEvery, label: Text("Due Every")) {
                            ForEach(TimePart.allCases, id: \.self) { timePart in
                                Text(timePart.rawValue  + "\(dueEveryAmount > 1 ? "s" : "")")
                            }
                        }
                        Picker(selection: $dueEveryAmount, label: Text("Due Every")) {
                            ForEach(1..<dueEvery.max(), id: \.self) {
                                Text(("\($0)"))
                            }
                        }
                        Toggle(isOn: $repeatsForever) {
                            Text("Forever")
                        }
                        if !repeatsForever {
                            Picker(selection: $repetitions, label: Text("Times")) {
                                ForEach(1...100, id: \.self) {
                                    Text(("\($0)"))
                                }
                            }
                        }
                    }
                }
                
                // last completed
                Section(header: Text("Last Completed"),
                        footer: Text("Counting from \( customCompletionDate ? "\(completetionDate.timeString()) \(completetionDate.dateString())" : "now")")) {
                    Toggle(isOn: $customCompletionDate) {
                        Text("Completed before")
                    }
                    if customCompletionDate {
                        DatePicker("On", selection: $completetionDate)
                        
                    }
                }// end last completed
                .alert(isPresented: $showingError) {
                    Alert(title: Text("Important message"), message: Text(error?.localizedDescription ?? "Unknown Error"), dismissButton: .default(Text("Got it!")))
                }
                
            } // Form
            .navigationBarTitle(Text("New Task"), displayMode: .inline)
            .navigationBarItems(
                leading:
                    Button("Cancel") {
                        self.presentationMode.wrappedValue.dismiss()
                    },
                trailing:
                    Button("Add") {
                        self.addTask()
                        self.presentationMode.wrappedValue.dismiss()
                    }
            )
        } // NavigationView

        
    } // body
    
    private func addTask() {
        withAnimation {
            let newTask = Task(context: viewContext)
            
            if !self.customCompletionDate {
                self.completetionDate = Date()
            }
            if self.repeatsForever {
                repetitionStatus = .forever
            } else if self.repetitions > 0 {
                repetitionStatus = .times
            }
            
            if self.dueType == .after {
                self.dueDate = self.completetionDate.addingTimeInterval(self.dueTimein(dueTimePart))
            }
            
            newTask.name = self.name
            newTask.due = self.dueDate
            newTask.lastComplete = self.completetionDate
            newTask.repetitions = self.repetitions
            newTask.repetitionStatus = self.repetitionStatus
            newTask.dueEvery = self.dueEvery
            newTask.dueEveryAmount = self.dueEveryAmount

            do {
                try viewContext.save()
                newTask.scheduleNotification()
            } catch let error as TaskError {
                self.error = error
                self.showingError = true
            } catch {
                print("made up error")
            }
        }
    }

    func dueTimein(_ timePart: TimePart) -> TimeInterval {
        var time = TimeInterval()
        time += timePart.seconds()
        return time
    }
    
}

struct TaskDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TaskDetailView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
