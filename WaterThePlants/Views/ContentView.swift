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
    @State var dueWithinSelection: String = "All"
    @State var dueFilterOff = false
    var timePartsToSelect: [TimePart] = [.day, .week, .month, .year]
    var timePartsToSelectWithAll: [String] = [TimePart.day.rawValue, TimePart.week.rawValue, TimePart.month.rawValue, TimePart.year.rawValue, "All"]
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
                .padding(.horizontal)
                if showingTaskStatus == .running {
                    Picker("Due within", selection: $dueWithinSelection.animation(.easeOut(duration: 0.4))) {
                        ForEach(timePartsToSelectWithAll, id: \.self) { timePart in
                            Text(timePart)
                        }
                        .padding()
                    }
                    .onChange(of: dueWithinSelection) { value in
                        withAnimation(.easeOut(duration: 0.4)) {
                            dueFilterOff = value == "All"
                            if value != "All" {
                                dueWithin = TimePart(rawValue: value) ?? .year
                            }
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal)
                }
                // results
                FilteredGrid(filter: showingTaskStatus.rawValue, showingTaskDetail: $showingTaskDetail, dueFilterOff: dueFilterOff, dueWithin: dueWithin, dummy: $dummy)
            }
            .padding(.vertical)
            .navigationBarTitle("", displayMode: .inline)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    VStack {
                        Text("") //  to seperate header better
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
