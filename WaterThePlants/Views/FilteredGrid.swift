//
//  FilteredGrid.swift
//  WaterThePlants
//
//  Created by Oliver Harvey on 04/12/2020.
//

import SwiftUI

struct FilteredGrid: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Binding var showingTaskDetail: Bool
    var dueWithin: TimePart = .year
    var moveIn: Edge
    var fetchRequest: FetchRequest<Task>
    private var tasks: FetchedResults<Task> { fetchRequest.wrappedValue }
    @Binding var dummy: Bool

    let columns = [
        GridItem(.adaptive(minimum: 400))
    ]
    init(filter: String, showingTaskDetail: Binding<Bool>, dueWithin: TimePart, dummy: Binding<Bool>) {
        
        fetchRequest = FetchRequest<Task>(entity: Task.entity(),
                                          sortDescriptors: [NSSortDescriptor(keyPath: \Task.dueDate, ascending: true)],
                                          predicate: NSPredicate(format: "taskStatusValue == %@", filter))
        self.moveIn = UIDevice.current.userInterfaceIdiom == .phone ? .trailing : .top
        self._dummy = dummy
        self._showingTaskDetail = showingTaskDetail
        self.dueWithin = dueWithin
    }
    
    var body: some View {
        ScrollView {
             LazyVGrid(columns: columns, spacing: 20) {
                ForEach(tasks.filter {$0.dueWithinTimeParts.contains(dueWithin)}) { task in
                     ProgressView(task: task, dummy: $dummy)
                        .padding(.vertical)
                        .transition(.move(edge: moveIn))
                 }
             }
         }
    }
}

