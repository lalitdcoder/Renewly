//
//  RenewlyApp.swift
//  Renewly
//

import SwiftUI
import SwiftData
import UserNotifications

@main
struct RenewlyApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            SubscriptionModel.self,
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
