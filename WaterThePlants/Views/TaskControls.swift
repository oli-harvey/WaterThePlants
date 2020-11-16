import SwiftUI

struct TaskControls: View {
    var task: Task
    @Binding var status: TaskViewStatus
    
    var body: some View {
        VStack {
                Button(action: {
                    print("task completed")
                    self.task.taskDone()
                    self.status = .normal
                } ) {
                    Image(systemName: "checkmark.circle")
                        .font(.largeTitle)
                        .foregroundColor(.green)
                        .clipped()
                        .shadow(color: .black, radius: 1)
                        .padding()
                }
        }
        .buttonStyle(PlainButtonStyle())
    }
}
