import SwiftUI

struct ProgressView: View {
    var task: Task
    @Environment(\.managedObjectContext) private var viewContext
    @State var showingText = false
    @State var showingTaskEdit: Bool = false
    
    @Binding var dummy: Bool
    @State var showTaskStatusAlert = false
    @State var doneSymbolSize: CGFloat = 0
    var doneSymbolSizeMax: CGFloat = 14
    @State var doneSymbolOpacity: Double = 0
    @State var doneSymbolColor: Color = .green
    @State var doneSymbol: String = "checkmark.circle"
    var moveIn: Edge {
      // showingTaskStatus == .running ? .trailing : .leading
        .leading
    }
    var circleSize: CGFloat {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return 160
        } else {
            return 230
        }
    }
        
    var body: some View {
        HStack {
            ZStack {
                ProgressBar(task: task, dummy: $dummy)
                    .padding()
                    .frame(width: circleSize, height: circleSize)
                Text(task.name ?? "No Task")
                    .font(.title)
                // zooming icon here
                Image(systemName: doneSymbol)
                    .scaleEffect(doneSymbolSize)
                    .opacity(doneSymbolOpacity)
                    .foregroundColor(doneSymbolColor)
            }
                if showingText  {
                    VStack {
                        if task.repetitionStatus != .none {
                            Spacer()
                        }
                        ProgressText(task: task, dummy: $dummy)
                        if task.repetitionStatus != .none {
                            CompletionsView(task: task, dummy: $dummy)
                        } 
                    }
                }
        }
            .actionSheet(isPresented: $showTaskStatusAlert) {
                ActionSheet(title: Text("Task Action"),
                            buttons: [.default(Text("Cancel")),
                                      .default(Text("Done")) {
                                        Sounds.playSounds(soundfile: "success3.mp3")
                                        withAnimation{ showingText = true }
                                        doneSymbolAnimation(symbol: "checkmark.circle")
                                        simpleSuccess()
                                        save()
                                      },
                                      .default(Text("Skip")) {
                                        withAnimation{ showingText = true }
                                        doneSymbolAnimation(symbol: "minus.circle")
                                        save()
                                      },
                                      .default(Text("Edit")) {
                                        showingTaskEdit = true
                                      },
                                      .destructive(Text("Delete")) {
                                        withAnimation {
                                            viewContext.delete(task)
                                        }
                                        save()
                                      }
                            ]
                            )
            }
            .sheet(isPresented: $showingTaskEdit) {
                EditView(taskViewData: TaskViewData(task: task))
            }
       

        .onTapGesture {
            withAnimation {
                showingText.toggle()
            }
        }
        .onLongPressGesture {
            withAnimation {
                showingText = true
            }
            showTaskStatusAlert = true
        }
    }
    func save() {
        do {
            try viewContext.save()
        } catch let error as TaskError {
            print(error.localizedDescription)
        } catch {
            print("made up error")
        }
    }
    func doneSymbolAnimation(symbol: String) {
        // check if showingtext is false, show it and add extra delay if not
        let scaleUpDuration = 0.4
        let fadeOutDuration = 0.05
        let shrinkDuration = 0.001
        let doneUpdateDelay = 0.5
    
        doneSymbol = symbol
        doneSymbolColor = doneSymbol == "checkmark.circle" ? .green : .red
        withAnimation(.easeIn(duration: scaleUpDuration)) {
            doneSymbolSize = doneSymbolSizeMax
            doneSymbolOpacity = 0.7
            
        }
        let deadline = DispatchTime.now() + scaleUpDuration
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            withAnimation(Animation.linear(duration: fadeOutDuration)) {
                doneSymbolOpacity = 0
            }
        }
        let deadline2 = DispatchTime.now() + scaleUpDuration + fadeOutDuration
        DispatchQueue.main.asyncAfter(deadline: deadline2) {
            withAnimation(Animation.linear(duration: shrinkDuration)) {
                doneSymbolSize = 0
            }
        }
        let deadline3 = DispatchTime.now() + scaleUpDuration + fadeOutDuration + doneUpdateDelay
        DispatchQueue.main.asyncAfter(deadline: deadline3) {
            withAnimation {
                if symbol == "checkmark.circle" {
                    task.taskDone()
                } else if symbol == "minus.circle" {
                    task.skipDone()
                }
                showingText = false
                dummy.toggle()
            }
        }
    }
    func simpleSuccess() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
}


struct ProgressView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressView(task: Task(), showingText: true, showingTaskEdit: true, dummy: .constant(true), showTaskStatusAlert: true)
    }
}
