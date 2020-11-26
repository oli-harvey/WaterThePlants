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
    @State var showingTaskDetail = false
    @State var dummy = false
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        NavigationView {
            VStack {
                Picker("Task Status", selection: $showingTaskStatus) {
                    ForEach(TaskStatus.allCases, id: \.self) { status in
                        Text(status.rawValue)
                    }
                    .padding()
                }
                    .pickerStyle(SegmentedPickerStyle())
                FilteredList(filter: showingTaskStatus.rawValue, showingTaskDetail: $showingTaskDetail, dummy: $dummy)

            }
            .padding(.vertical)
            .navigationBarTitle("", displayMode: .inline)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    HStack {
                        Image("Logo")
                            .resizable()
                            .frame(width: 40, height:40, alignment: .leading)
                        Text("Water the Plants")
                            .font(.largeTitle)
                    }
                    .padding()
                    
                }
                ToolbarItemGroup(placement: .bottomBar) {
                    Spacer()
                    Button(action: {showingTaskDetail = true}) {
                        Label("Add Task", systemImage: "plus.circle")
                            .font(.largeTitle)
                    }
                    .padding()
                    
                }
            }
            
        } // NavigationView
        .sheet(isPresented: $showingTaskDetail) {
            EditView(taskViewData: TaskViewData())
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
