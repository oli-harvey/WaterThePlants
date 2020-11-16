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
    @State var showTaskDetail = false
    @State var dummy = false
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        NavigationView {
            VStack {
                Text(showingTaskStatus.rawValue)
                Picker("Task Status", selection: $showingTaskStatus) {
                    ForEach(TaskStatus.allCases, id: \.self) { status in
                        Text(status.rawValue)
                    }
                }
                    .pickerStyle(SegmentedPickerStyle())
                FilteredList(filter: showingTaskStatus.rawValue, dummy: $dummy)

            }
            .toolbar {
                Button(action: {showTaskDetail = true}) {
                    Label("Add Task", systemImage: "plus")
                        .font(.largeTitle)
                }
                
        }
            .navigationTitle("Water the Plants")
        } // NavigationView
        .sheet(isPresented: $showTaskDetail) {
            TaskDetailView()
        }
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
