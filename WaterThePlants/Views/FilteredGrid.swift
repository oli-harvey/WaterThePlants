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
    var moveIn: Edge
    var fetchRequest: FetchRequest<Task>
    private var tasks: FetchedResults<Task> { fetchRequest.wrappedValue }
    @Binding var dummy: Bool

    let columns = [
        GridItem(.adaptive(minimum: 400))
    ]
    init(filter: String, showingTaskDetail: Binding<Bool>, dummy: Binding<Bool>) {
        
        fetchRequest = FetchRequest<Task>(entity: Task.entity(),
                                          sortDescriptors: [NSSortDescriptor(keyPath: \Task.dueDate, ascending: true)],
                                          predicate: NSPredicate(format: "taskStatusValue == %@", filter))
        self.moveIn = TaskStatus(rawValue: filter) == .running ? .trailing : .leading
        self._dummy = dummy
        self._showingTaskDetail = showingTaskDetail
    }
    
    var body: some View {
        ScrollView {
             LazyVGrid(columns: columns, spacing: 20) {
                 ForEach(tasks) { task in
                     ProgressView(task: task, dummy: $dummy)
                        .padding(.vertical)
                 }
             }
         }
    }
}

