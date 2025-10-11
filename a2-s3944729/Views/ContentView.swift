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
    @StateObject private var toastNotificationService = ToastNotificationService()
    
    var body: some View {
        ZStack(alignment: .top) {
            if showMainView {
                MainView()
            } else {
                IntroductionView(showMainView: $showMainView)
            }
            if toastNotificationService.showToast {
                ToastHostView(message: toastNotificationService.message)
                    .frame(height: 90)
            }
        }.environmentObject(toastNotificationService)
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [StoredIngredient.self, StoredRecipe.self], inMemory: true)
}
