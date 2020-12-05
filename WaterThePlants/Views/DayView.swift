//
//  DayView.swift
//  WaterThePlants
//
//  Created by Oliver Harvey on 04/12/2020.
//

//import SwiftUI
//
//struct DayView: View {
//    @Environment(\.managedObjectContext) private var viewContext
//    var fetchRequest: FetchRequest<Task>
//    private var tasks: FetchedResults<Task> { fetchRequest.wrappedValue }
//    @Binding var dummy: Bool
//
//    let columns = [
//        GridItem(.adaptive(minimum: 400))
//    ]
//    init(dummy: Binding<Bool>) {
//        let calendar = Calendar.current
//        //Get today's beginning & end
//        let dateFrom = calendar.startOfDay(for: Date()) // eg. 2016-10-10 00:00:00
//        let dateTo = calendar.date(byAdding: .day, value: 1, to: dateFrom)!
//        let fromPredicate = NSPredicate(format: "dueDate >= %@", dateFrom as NSDate)
//        let toPredicate = NSPredicate(format: "dueDate < %@", dateTo as NSDate)
//        let statusPredicate = NSPredicate(format: "taskStatusValue == %@", "Running")
//        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [fromPredicate, toPredicate, statusPredicate])
//        
//        fetchRequest = FetchRequest<Task>(entity: Task.entity(),
//                                          sortDescriptors: [NSSortDescriptor(keyPath: \Task.dueDate, ascending: true)],
//                                          predicate: predicate)
//        self._dummy = dummy
//    }
