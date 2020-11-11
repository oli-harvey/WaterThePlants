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
                    Text(task.due.dateTimeString())
                    Text(task.completionDescTime)
                }
            }
                .font(.caption)
            HStack {
                VStack(alignment: .trailing) {
                    Text("last:")
                    Text("   ")
                }
                VStack(alignment: .leading) {
                    Text(task.lastComplete.dateTimeString())
                    Text(task.lastCompleteTimeSince.format())
                }
            }
                .font(.caption)
        }
        .padding(0)
        .foregroundColor(dummy ? .blue : .blue)
    }
}

