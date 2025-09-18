//
//  a2_s3944729App.swift
//  a2-s3944729
//
//  Created by Jake Parkinson on 8/9/2025.
//

import SwiftData
import SwiftUI

@main
struct a2_s3944729App: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: StoredIngredient.self) // uses default on-disk store
    }
}
