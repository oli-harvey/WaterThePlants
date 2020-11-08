import SwiftUI

struct ProgressBar: View {
    var task: Task
    @State private var status: TaskViewStatus = .normal

    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 20.0)
                .opacity(0.3)
                .foregroundColor(task.colour)
            
            Circle()
                .trim(from: 0.0, to: task.percentComplete)
                .stroke(style: StrokeStyle(lineWidth: 20.0, lineCap: .round, lineJoin: .round))
                .foregroundColor(task.colour)
                .rotationEffect(Angle(degrees: 270))
                .animation(.linear)
        }
        .contentShape(Circle())
    }
}
