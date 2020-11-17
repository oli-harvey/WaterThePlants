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
              //  TaskControls(task: task, status: $taskViewStatus)
            }
            .alert(isPresented: $showTaskStatusAlert) {
                Alert(title: Text("Confirm Done"),
                     primaryButton: .destructive(Text("Cancel")),
                     secondaryButton: .default(Text("Done")) {
                        task.taskDone()
                     })
            }
        }

        .onTapGesture {
            showTaskStatusAlert = true
        }
        
    }
}

struct PrgoressView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressView(task: Task(), dummy: .constant(true))
    }
}

