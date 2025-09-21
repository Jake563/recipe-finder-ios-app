//
//  StepClarificationView.swift
//  a2-s3944729
//
//  View that provides clarification on a step
//
//  Created by Jake Parkinson on 10/9/2025.
//

import SwiftUI

struct StepClarificationView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var stepClarification: String = ""
    private let aiService = AiService(session: URLSession.shared)
    
    let instruction: Instruction
    
    private func loadStepClarification() {
        Task {
            stepClarification = await aiService.getRecipeStepClarification(instruction: instruction)
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "xmark")
                        .foregroundStyle(.black)
                }
                Text("Step clarification")
                    .bold()
                Spacer()
            }
            if stepClarification.isEmpty {
                Spacer()
                ProgressView()
            } else {
                HStack {
                    Text(stepClarification)
                    Spacer()
                }
            }
            Spacer()
        }
        .padding()
        .onAppear() {
            loadStepClarification()
        }
    }
}

#Preview {
    StepClarificationView(instruction: Instruction(instruction: "This is a test instruction", timer: 0))
}
