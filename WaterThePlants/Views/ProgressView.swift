import SwiftUI

struct ProgressView: View {
    var task: Task
    @State var taskViewStatus: TaskViewStatus = .normal
    
    var body: some View {
        VStack {
            Text(task.name)
                .font(.title)
            ZStack {
                ProgressBar(task: task)
                    .padding()
                    .frame(minWidth: 150, minHeight: 150)
                ProgressText(task: task, status: $taskViewStatus)
            }
        }
    }
}

struct PrgoressView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressView(task: Task())
    }
}

