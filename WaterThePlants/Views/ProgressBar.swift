import SwiftUI

struct ProgressBar: View {
    var task: Task
    @Binding var dummy: Bool
//    @State var ticks = 12
    

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
                ForEach(0 ..< task.tickNumber, id: \.self) { i in
                    Rectangle()
                        .fill(Color.primary)
                        .cornerRadius(2)
                        .opacity(0.1)
                     //   .frame(width: 1, height: (i % 5) == 0 ? 15 : 10)
                        .frame(width: 2, height: 12)
                        .offset(y: -58)
                    //    .offset(y: (geo.size.width - 180) / 2)
                        .rotationEffect(Angle.degrees(Double(i) / Double(task.tickNumber) * 360))
                }
                VStack {
                    Spacer()
                    HStack {
                        Text("\(task.tickUnit.rawValue)s")
                    }
                }
            }
            .contentShape(Circle())
            .foregroundColor(dummy ? .primary : .primary)
        }

    }
}
