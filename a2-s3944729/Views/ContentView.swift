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
        ZStack {
            if showMainView {
                MainView()
            } else {
                IntroductionView(showMainView: $showMainView)
            }
            ToastHostView(message: toastNotificationService.message, show: toastNotificationService.showToast)
        }.environmentObject(toastNotificationService)
    }
}

#Preview {
    ContentView()
        .modelContainer(for: StoredIngredient.self, inMemory: true)
}
