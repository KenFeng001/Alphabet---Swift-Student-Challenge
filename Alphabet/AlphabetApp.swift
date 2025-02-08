//
//  AlphabetApp.swift
//  Alphabet
//
//  Created by Zile Feng on 03/02/2025.
//

import SwiftUI
import SwiftData

@main
struct AlphabetApp: App {
    let container: ModelContainer

    init() {
        do {
            container = try ModelContainer(for: PhotoItem.self, PhotoCollection.self)
        } catch {
            fatalError("Failed to initialize ModelContainer: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            ViewfinderView()
        }
        .modelContainer(container)

    }
}
