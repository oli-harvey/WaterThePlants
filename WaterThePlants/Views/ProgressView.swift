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
    var circleSize: CGFloat {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return 160
        } else {
            return 230
        }
    }
        
    var body: some View {
        HStack {
            ZStack {
                ProgressBar(task: task, dummy: $dummy)
                    .padding()
                    .frame(width: circleSize, height: circleSize)
                Text(task.name ?? "No Task")
                    .font(.title)
            }
                if showingText  {
                    VStack {
                        if task.repetitionStatus != .none {
                            Spacer()
                        }
                        ProgressText(task: task, dummy: $dummy)
                        if task.repetitionStatus != .none {
                            CompletionsView(task: task, dummy: $dummy)
                        } 
                    }
                }
        }
            .transition(.move(edge: .bottom))
            .actionSheet(isPresented: $showTaskStatusAlert) {
                ActionSheet(title: Text("Task Action"),
                            buttons: [.default(Text("Cancel")),
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
                                      },
                                      .destructive(Text("Delete")) {
                                        withAnimation {
                                            viewContext.delete(task)
                                        }
                                        save()
                                      }
                            ]
                            )
            }
            .sheet(isPresented: $showingTaskEdit) {
                EditView(taskViewData: TaskViewData(task: task))
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
