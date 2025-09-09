//
//  RecipeInstructionsView.swift
//  a2-s3944729
//
//  View that contains all the steps for a recipe, only showing one step at a time.
//
//  Created by Jake Parkinson on 9/9/2025
//

import SwiftUI

struct RecipeInstructionsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var currentInstruction: Instruction
    @State private var currentInstructionIndex: Int
    
    let recipe: Recipe
    
    private func nextStep() {
        if currentInstructionIndex == recipe.instructions.count - 1 {
            return
        }
        currentInstructionIndex = currentInstructionIndex + 1
        currentInstruction = recipe.instructions[currentInstructionIndex]
    }
    
    private func prevStep() {
        if currentInstructionIndex == 0 {
            return
        }
        currentInstructionIndex = currentInstructionIndex - 1
        currentInstruction = recipe.instructions[currentInstructionIndex]
    }
    
    init(recipe: Recipe) {
        self.recipe = recipe
        self.currentInstruction = recipe.instructions[0]
        self.currentInstructionIndex = 0
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Text(currentInstruction.instruction)
                    Spacer()
                }
                Spacer()
                VStack {
                    HStack {
                        Image(systemName: "clock")
                        Text("07:00")
                    }
                    Button(action: {
                        nextStep()
                    }) {
                        Text("Start Timer")
                    }
                    .font(.title)
                    .buttonStyle(PrimaryButtonStyle())
                }
                Spacer()
                HStack {
                    if currentInstructionIndex != 0 {
                        Button(action: {
                            prevStep()
                        }) {
                            Text("< Prev")
                        }
                        .font(.title)
                        .buttonStyle(PrimaryButtonStyle())
                    }
                    Spacer()
                    if currentInstructionIndex != recipe.instructions.count - 1 {
                        Button(action: {
                            nextStep()
                        }) {
                            Text("Next >")
                        }
                        .font(.title)
                        .buttonStyle(PrimaryButtonStyle())
                    }
                }
            }
            .padding()
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "arrow.left")
                            .foregroundColor(.black)
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("Step \(currentInstructionIndex + 1)")
                        .font(.title)
                }
                ToolbarItem() {
                    Button(action: {
                        print("Help")
                    }) {
                        Image(systemName: "questionmark.circle")
                            .foregroundColor(.black)
                    }
                }
            }
        }
    }
}

#Preview {
    RecipeInstructionsView(recipe: Recipe(
        name: "Test Recipe",
        estimatedTime: "40 minutes",
        ingredients: [
            RequiredIngredient(name: "Egg", quantity: 50, quantityMassUnit: nil),
            RequiredIngredient(name: "Milk", quantity: 20, quantityMassUnit: "mL")
        ],
        instructions: [
            Instruction(instruction: "Preheat stove top for 10 minutes.", timer: 180),
            Instruction(instruction: "Crack eggs into pan.", timer: 0)
        ]
    ))
}
