//
//  FilteredList.swift
//  WaterThePlants
//
//  Created by Oliver Harvey on 16/11/2020.
//

import SwiftUI

struct FilteredList: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Binding var showingTaskDetail: Bool
    var moveIn: Edge
    var fetchRequest: FetchRequest<Task>
    private var tasks: FetchedResults<Task> { fetchRequest.wrappedValue }
    @Binding var dummy: Bool
    
    init(filter: String, showingTaskDetail: Binding<Bool>, dummy: Binding<Bool>) {
        
        fetchRequest = FetchRequest<Task>(entity: Task.entity(),
                                          sortDescriptors: [NSSortDescriptor(keyPath: \Task.dueDate, ascending: true)],
                                          predicate: NSPredicate(format: "taskStatusValue == %@", filter))
      //  self._moveIn = State(initialValue: TaskStatus(rawValue: filter) == .running ? .leading : .trailing)
        self.moveIn = TaskStatus(rawValue: filter) == .running ? .trailing : .leading
        self._dummy = dummy
        self._showingTaskDetail = showingTaskDetail
    }
    
    var body: some View {
        List {
            ForEach(tasks) { task in
                ProgressView(task: task, dummy: $dummy)
                    .transition(.move(edge: moveIn))
            }
            .onDelete(perform: deleteItems)
        }
    }
    func deleteItems(offsets: IndexSet) {
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

struct FilteredList_Previews: PreviewProvider {
    static var previews: some View {
        FilteredList(filter: "Running", showingTaskDetail: .constant(true), dummy: .constant(true))
    }
}
