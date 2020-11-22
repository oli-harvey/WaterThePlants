//
//  FilteredList.swift
//  WaterThePlants
//
//  Created by Oliver Harvey on 16/11/2020.
//

import SwiftUI

struct FilteredList: View {
    @Environment(\.managedObjectContext) private var viewContext
    var fetchRequest: FetchRequest<Task>
    init(filter: String, dummy: Binding<Bool>) {
        
        fetchRequest = FetchRequest<Task>(entity: Task.entity(),
                                          sortDescriptors: [NSSortDescriptor(keyPath: \Task.due, ascending: true)],
                                          predicate: NSPredicate(format: "taskStatusValue == %@", filter), animation: .default)
        self._dummy = dummy
    }
    private var tasks: FetchedResults<Task> { fetchRequest.wrappedValue }
    @Binding var dummy: Bool
    
    var body: some View {
        List {
            ForEach(tasks) { task in
                ProgressView(task: task, dummy: $dummy)
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
        FilteredList(filter: "Running", dummy: .constant(true))
    }
}