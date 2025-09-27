//
//  ContentView.swift
//  a2-s3944729
// 
//  Created by Jake Parkinson on 8/9/2025.
//

import SwiftUI

/// View that displays the entire app.
struct ContentView: View {
    @State private var showMainView = false
    
    var body: some View {
        if showMainView {
            MainView()
        } else {
            IntroductionView(showMainView: $showMainView)
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: StoredIngredient.self, inMemory: true)
}
