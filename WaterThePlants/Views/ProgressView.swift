import SwiftUI

struct ProgressView: View {
    var task: Task
    @Environment(\.managedObjectContext) private var viewContext
    @State var showingText = false
    @State var showingTaskEdit: Bool = false
    
    @Binding var dummy: Bool
    @State var showTaskStatusAlert = false
    var moveIn: Edge {
      // showingTaskStatus == .running ? .trailing : .leading
        .leading
    }
        
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
            .transition(.move(edge: .trailing))
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
                                        showingTaskEdit = true
                                      }
                            ]
                            )
            }
            .sheet(isPresented: $showingTaskEdit) {
                EditView(taskViewData: TaskViewData(task: task))
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


struct ProgressView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressView(task: Task(), showingText: true, showingTaskEdit: true, dummy: .constant(true), showTaskStatusAlert: true)
    }
}
