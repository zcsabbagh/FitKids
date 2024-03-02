//
//  FitKids_CCApp.swift
//  FitKids-CC
//
//  Created by Zane Sabbagh on 3/1/24.
//

import SwiftUI

@main
struct FitKids_CCApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
