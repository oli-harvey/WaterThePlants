//
//  FilteredGrid.swift
//  WaterThePlants
//
//  Created by Oliver Harvey on 04/12/2020.
//

import SwiftUI

struct FilteredGrid: View {
    @Environment(\.managedObjectContext) private var viewContext
//    @Binding var showingTaskDetail: Bool
    var dueFilterOff: Bool = false
    var dueWithin: TimePart = .year
//    var moveIn: Edge
    var fetchRequest: FetchRequest<Task>
    private var tasks: FetchedResults<Task> { fetchRequest.wrappedValue }
    @Binding var dummy: Bool

    let columns = [
        GridItem(.adaptive(minimum: 400))
    ]
    init(filter: String, dueFilterOff: Bool, dueWithin: TimePart, dummy: Binding<Bool>) {
        
        fetchRequest = FetchRequest<Task>(entity: Task.entity(),
                                          sortDescriptors: [NSSortDescriptor(keyPath: \Task.dueDate, ascending: true)],
                                          predicate: NSPredicate(format: "taskStatusValue == %@", filter))
   //     self.moveIn = UIDevice.current.userInterfaceIdiom == .phone ? .trailing : .top
        self._dummy = dummy
//        self._showingTaskDetail = showingTaskDetail
        self.dueWithin = dueWithin
        self.dueFilterOff = dueFilterOff
    }
    
    var body: some View {
        ScrollView {
             LazyVGrid(columns: columns, spacing: 20) {
                ForEach(tasksFiltered()) { task in
                     ProgressView(task: task, dummy: $dummy)
                        .padding(.vertical)
                     //   .transition(.move(edge: moveIn))
                        .transition(.scale)
                 }                
             }
         }
    }
    func tasksFiltered() -> [Task] {
        if dueFilterOff {
            return tasks.compactMap{ $0 }
        } else {
            return tasks.filter {$0.dueWithinTimeParts.contains(dueWithin)}
        }
    }
}

