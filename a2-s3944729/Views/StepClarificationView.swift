//
//  StepClarificationView.swift
//  a2-s3944729
//
//  Created by Jake Parkinson on 10/9/2025.
//

import SwiftUI

struct StepClarificationView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var stepClarification: String = ""
    
    let instruction: Instruction
    let loadClarification: Bool
    
    private func loadStepClarification() {
        if !loadClarification {
            return
        }
        Task {
            stepClarification = await AiService.clarifyRecipeStep(instruction: instruction)
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
            HStack {
                Text(stepClarification)
                Spacer()
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
    StepClarificationView(instruction: Instruction(instruction: "This is a test instruction", timer: 0), loadClarification: false)
}
