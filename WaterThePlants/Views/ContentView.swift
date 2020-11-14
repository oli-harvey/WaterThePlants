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
    @FetchRequest(entity: Task.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Task.due, ascending: true)],
        animation: .default)
    private var tasks: FetchedResults<Task>
    
    @State var showTaskDetail = false
    @State var dummy = false
    @State var deleteInProgress = false
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        NavigationView {
            List {
                ForEach(tasks) { task in
                    ProgressView(task: task, dummy: $dummy)
                }
                .onDelete(perform: deleteItems)
            }

            .toolbar {
                HStack {
                    Button(action: {showTaskDetail = true}) {
                        Label("Add Task", systemImage: "plus")
                    }
                    Text("tasks: \(tasks.count)")
                }
                
        }
        } // NavigationView
        .sheet(isPresented: $showTaskDetail) {
            TaskDetailView()
        }
        .onReceive(timer) { input in
            if !deleteInProgress {
                self.dummy.toggle()
            }
            deleteInProgress = false
        }
        .foregroundColor(dummy ? .primary : .primary)
    }



    private func deleteItems(offsets: IndexSet) {
        deleteInProgress = true
        
        withAnimation {
            offsets.map { tasks[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
