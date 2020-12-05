//
//  ContentView.swift
//  WaterThePlants
//
//  Created by Oliver Harvey on 07/11/2020.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State var showingTaskStatus: TaskStatus = .running
    @State var dueWithin: TimePart = .year
    var timePartsToSelect: [TimePart] = [.day, .week, .month, .year]
    @State var showingTaskDetail = false
    @State var dummy = false
    var moveIn: Edge {
      // showingTaskStatus == .running ? .trailing : .leading
        .leading
    }
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        NavigationView {
            VStack {
                // filter controls
                Picker("Task Status", selection: $showingTaskStatus.animation(Animation.easeOut(duration: 0.4))) {
                    ForEach(TaskStatus.allCases, id: \.self) { status in
                        Text(status.rawValue)
                    }
                    .padding()
                }
                    .pickerStyle(SegmentedPickerStyle())
                if showingTaskStatus == .running {
                    Picker("Due within", selection: $dueWithin.animation(.easeOut(duration: 0.4))) {
                        ForEach(timePartsToSelect, id: \.self) { timePart in
                            Text(timePart.rawValue)
                        }
                        .padding()
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                // results
                FilteredGrid(filter: showingTaskStatus.rawValue, showingTaskDetail: $showingTaskDetail, dueWithin: dueWithin, dummy: $dummy)
            }
            .padding(.vertical)
            .navigationBarTitle("", displayMode: .inline)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    VStack {
                        HStack {
                            Image("Logo")
                                .resizable()
                                .frame(width: 40, height:40, alignment: .leading)
                                .cornerRadius(10)
                                .padding(.vertical)
                            Text("Water the Plants")
                                .font(.largeTitle)
                                .padding(.vertical)
                        }
                        .padding()
                        Text("") //  to seperate header better
                    }
                    
                }
                ToolbarItemGroup(placement: .bottomBar) {
                    Spacer()
                    Button(action: {showingTaskDetail = true}) {
                        Label("Add Task", systemImage: "plus.circle")
                            .font(.largeTitle)
                    }
                }
            }
            
        } // NavigationView
        .sheet(isPresented: $showingTaskDetail) {
            EditView(taskViewData: TaskViewData())
        }
        .navigationViewStyle(StackNavigationViewStyle())
        

        .onReceive(timer) { input in
            self.dummy.toggle()
        }
        .foregroundColor(dummy ? .primary : .primary)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
