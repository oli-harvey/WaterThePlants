import SwiftUI

struct ProgressView: View {
    var task: Task
    @State var taskViewStatus: TaskViewStatus = .normal
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
                ProgressText(task: task, status: $taskViewStatus, dummy: $dummy)
                    .padding(.trailing)
                if task.repetitionStatus != .none {
                    Text("Completed: \(task.timesCompleted) times")
                    Text("Skipped: \(task.timesSkipped) times")
                    CompletionsView(task: task, dummy: $dummy)
                }
              //  TaskControls(task: task, status: $taskViewStatus)
            }
            .actionSheet(isPresented: $showTaskStatusAlert) {
                ActionSheet(title: Text("Confirm Done"),
                            buttons: [.destructive(Text("Cancel")),
                                      .default(Text("Done")) {
                                        task.taskDone()
                                      },
                                      .default(Text("Skip")) {
                                        task.skipDone()
                                      }]
                            )
            }
        }

        .onTapGesture {
            showTaskStatusAlert = true
        }
        
    }
}


