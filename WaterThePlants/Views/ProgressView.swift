import SwiftUI

struct ProgressView: View {
    var task: Task
    @Environment(\.managedObjectContext) private var viewContext
    @State var showingText = false
    @Binding var showingTaskDetail: Bool
    @Binding var dummy: Bool
    @State var showTaskStatusAlert = false
        
    var body: some View {
        HStack {
            ZStack {
                ProgressBar(task: task, dummy: $dummy)
                    .padding()
                    .frame(minWidth: 150, minHeight: 150)
                Text(task.name ?? "No Task")
                    .font(.title)
            }
            VStack {
                if showingText  {
                    ProgressText(task: task, dummy: $dummy)
                    if task.repetitionStatus != .none {
                        CompletionsView(task: task, dummy: $dummy)
                    }
                }
               
                
            }
            .actionSheet(isPresented: $showTaskStatusAlert) {
                ActionSheet(title: Text("Confirm Done"),
                            buttons: [.destructive(Text("Cancel")),
                                      .default(Text("Done")) {
                                        task.taskDone()
                                        dummy.toggle()
                                        save()
                                      },
                                      .default(Text("Skip")) {
                                        task.skipDone()
                                        dummy.toggle()
                                        save()
                                      },
                                      .default(Text("Edit")) {
                                        showingTaskDetail = true
                                      }
                            ]
                            )
            }
            .sheet(isPresented: $showingTaskDetail) {
                TaskDetailView(editMode: true, task: task)
            }
        }

        .onTapGesture {
            withAnimation {
                showingText.toggle()
            }
        }
        .onLongPressGesture {
            showTaskStatusAlert = true
        }
    }
    func save() {
        do {
            try viewContext.save()
        } catch let error as TaskError {
            print(error.localizedDescription)
        } catch {
            print("made up error")
        }
    }
}


