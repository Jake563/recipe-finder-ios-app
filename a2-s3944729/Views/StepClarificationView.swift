//
//  StepClarificationView.swift
//  a2-s3944729
//
//  Created by Jake Parkinson on 10/9/2025.
//

import SwiftUI

struct StepClarificationView: View {
    @Environment(\.dismiss) private var dismiss
    let instruction: Instruction
    
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
                Text("This step asks you...")
                Spacer()
            }
            Spacer()
        }
        .padding()
    }
}

#Preview {
    StepClarificationView(instruction: Instruction(instruction: "test", timer: 0))
}
