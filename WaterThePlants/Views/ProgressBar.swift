import SwiftUI

struct ProgressBar: View {
    var task: Task
    @Binding var dummy: Bool

    var body: some View {
        GeometryReader { geo in
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
            .foregroundColor(dummy ? .primary : .primary)
            .shadow(color: Color(red), radius: dummy ? task.shadowSize() : 0 )
            .shadow(color: .primary, radius: dummy ? task.shadowSize() : 0 )
            .shadow(color: Color(red), radius: dummy ? task.shadowSize() : 0 )
        }

    }
}

