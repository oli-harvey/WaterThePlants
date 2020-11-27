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
    var moveIn: Edge {
       showingTaskStatus == .running ? .trailing : .leading
    }
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        NavigationView {
            VStack {
                Picker("Task Status", selection: $showingTaskStatus.animation()) {
                    ForEach(TaskStatus.allCases, id: \.self) { status in
                        Text(status.rawValue)
                    }
                    .padding()
                }
                    .pickerStyle(SegmentedPickerStyle())
                FilteredList(filter: showingTaskStatus.rawValue, showingTaskDetail: $showingTaskDetail, dummy: $dummy)
                    .transition(.move(edge: moveIn))

            }
            .padding(.vertical)
            .navigationBarTitle("", displayMode: .inline)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
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
