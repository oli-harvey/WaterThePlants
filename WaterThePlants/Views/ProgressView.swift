import SwiftUI

struct ProgressView: View {
    var task: Task
    @State var taskViewStatus: TaskViewStatus = .normal
    @Binding var dummy: Bool
    
    var body: some View {
        VStack {
            Text(task.name)
                .font(.title)
            ZStack {
                ProgressBar(task: task, dummy: $dummy)
                    .padding()
                    .frame(minWidth: 150, minHeight: 150)
                ProgressText(task: task, status: $taskViewStatus, dummy: $dummy)
            }
        }
    }
}

struct PrgoressView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressView(task: Task(), dummy: .constant(true))
    }
}

