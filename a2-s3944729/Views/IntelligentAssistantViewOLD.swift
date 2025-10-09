//
//  IntelligentAssistantView.swift
//  a2-s3944729
//
//  Created by Jake Parkinson on 8/10/2025.
//

import SwiftUI
import SwiftData

struct IntelligentAssistantView: View {
    @Environment(\.modelContext) private var context

    var body: some View {
        Text("How can I help?")
        Text("Ask me anything. For example 'Add 5 apples and 2 bananas'")
        Button(action: {
            let intelligentAssistantService = IntelligentAssistantService(context: context)
            Task {
                let response = await intelligentAssistantService.performActions(userRequest: "Remove apples")
            }
        }) {
            Text("Test")
        }
    }
    
}

#Preview {
    IntelligentAssistantView()
}
