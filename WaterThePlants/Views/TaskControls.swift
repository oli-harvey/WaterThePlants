//import SwiftUI
//
//struct TaskControls: View {
//    var task: Task
//    @Binding var status: TaskViewStatus
//    
//    var body: some View {
//        VStack {
//            Spacer()
//            HStack {
//                Button(action: {
//                    print("task dismissed")
//                    self.task.setToCancelled()
//                    self.status = .normal
//                } ) {
//                    Image(systemName: "xmark.circle")
//                        .font(.system(size: 50))
//                        .foregroundColor(.red)
//                }
//                .shadow(color: .black, radius: 1)
//                Button(action: {
//                    print("task completed")
//                    self.task.taskDone()
//                    self.status = .normal
//                } ) {
//                    Image(systemName: "checkmark.circle")
//                        .font(.system(size: 50))
//                        .foregroundColor(.green)
//                }
//                .shadow(color: .black, radius: 1)
//                
//            }
//            
//        }
//    }
//}
