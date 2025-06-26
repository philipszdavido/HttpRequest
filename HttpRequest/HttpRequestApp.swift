//
//  HttpRequestApp.swift
//  HttpRequest
//
//  Created by Chidume Nnamdi on 24/05/2024.
//

import SwiftUI
import SwiftData

@main
struct HttpRequestApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
            History.self,
            Collection.self
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
