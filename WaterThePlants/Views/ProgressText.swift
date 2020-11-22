import SwiftUI

struct ProgressText: View {
   var task: Task
   @Binding var dummy: Bool
    
    var body: some View {
        HStack {
            VStack(alignment: .trailing) {
                Text("due:")
                Text("   ")
                Text("last:")
                Text("   ")
                if task.repetitionStatus != .none {
                    Text("done:")
                    Text("left:")
                }

            }
            VStack(alignment: .leading) {
                Text(task.due?.dateTimeString() ?? Date().dateTimeString())
                Text(task.completionDescTime)
                Text(task.lastComplete?.dateTimeString() ?? Date().dateTimeString())
                Text(task.lastCompleteTimeSince.format())
                if task.repetitionStatus != .none {
                    Text("\(task.timesCompleted)")
                    Text("\(task.repsLeft)")
                }
            }
        }
        .font(.subheadline)
        .foregroundColor(dummy ? .primary : .primary)
    }
}
