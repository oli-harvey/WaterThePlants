import SwiftUI

struct ProgressText: View {
   var task: Task
   @Binding var status: TaskViewStatus
   @Binding var dummy: Bool
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .trailing) {
                    Text("due:")
                        
                }
                VStack(alignment: .leading) {
                    Text(task.due?.dateTimeString() ?? Date().dateTimeString())
                    Text(task.completionDescTime)
                }
            }
            HStack {
                VStack(alignment: .trailing) {
                    Text("last:")
                    Text("   ")
                }
                VStack(alignment: .leading) {
                    Text(task.lastComplete?.dateTimeString() ?? Date().dateTimeString())
                    Text(task.lastCompleteTimeSince.format())
                }
            }
            if task.repetitionStatus != .none {
                Text("Completed: \(task.timesCompleted)")
                Text("Reps: \(task.repsLeft)")
            }
        }
        .font(.subheadline)
        .foregroundColor(dummy ? .primary : .primary)
    }
}

