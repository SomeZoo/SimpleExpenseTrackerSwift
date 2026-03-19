//
//  SimpleExpenseTrackerSwiftApp.swift
//  SimpleExpenseTrackerSwift
//
//  Created by 朱远章 on 2026/3/19.
//

import SwiftUI
import SwiftData

@main
struct SimpleExpenseTrackerSwiftApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
