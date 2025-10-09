//
//  IntelligentAssistantView.swift
//  a2-s3944729
//
//  Created by Jake Parkinson on 8/10/2025.
//

import SwiftUI

struct IntelligentAssistantView: View {
    @Environment(\.modelContext) private var context
    
    var body: some View {
        Text("How can I help you?")
        Button(action: {
            let intellgent = IntelligentAssistantService(context: context)
            Task {
                let response = await intellgent.performActions(userRequest: "Add 2 garlic, 3 apples and 2 bananas")
            }
        }) {
            Text("Test")
        }
    }
    
}

#Preview {
    IntelligentAssistantView()
}
