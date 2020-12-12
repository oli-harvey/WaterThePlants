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
                Text(task.dueDate?.dateTimeString() ?? Date().dateTimeString())
                Text(task.completionDescTime)
                Text(task.completionDate?.dateTimeString() ?? Date().dateTimeString())
                Text(task.lastCompleteTimeSince.format())
                if task.repetitionStatus != .none {
                    Text("\(task.timesCompleted)")
                    Text("\(task.repsLeft)")
                }
            }
        }
        .font(.caption)
        .foregroundColor(dummy ? .primary : .primary)
    }
}

struct ProgressText2: View {
   var task: Task
   @Binding var dummy: Bool
   @Binding var showingText: Bool
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text( "due:")
                        .font(.caption)
                        .frame(alignment:.leading)
                    Text(task.completionDescTime)
                        .font(.headline)
                    Spacer()
                }
                Spacer()
                if showingText {
                    VStack(alignment: .trailing) {
                        Text( "last:")
                            .font(.caption)
                            .frame(alignment:.trailing)
                        Text(task.lastCompleteTimeSince.format())
                            .font(.headline)
                        if task.repetitionStatus != .none {
                            Text( "completed:")
                                .font(.caption)
                                .frame(alignment:.trailing)
                            Text("\(task.timesCompleted) / \(task.repsLeft)")
                                .font(.headline)
                        }
                        Spacer()
                    }
                }
            }
            Spacer()
         
        }
        .padding()
        .foregroundColor(dummy ? .primary : .primary)
    }
}
