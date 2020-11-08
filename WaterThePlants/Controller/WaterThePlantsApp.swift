//
//  WaterThePlantsApp.swift
//  WaterThePlants
//
//  Created by Oliver Harvey on 07/11/2020.
//

import SwiftUI

@main
struct WaterThePlantsApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

