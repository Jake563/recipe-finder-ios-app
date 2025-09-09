//
//  RecipeInstructionsView.swift
//  a2-s3944729
//
//  View that contains all the steps for a recipe, only showing one step at a time.
//
//  Created by Jake Parkinson on 9/9/2025.
//

import SwiftUI

struct RecipeInstructionsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var currentStep: String = "Preheat oven for 8 minutes"
    @State private var currentStepIndex: Int = 0
    
    let recipe: Recipe
    
    private func nextStep() {

    }
    
    private func prevStep() {

    }
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Text(currentStep)
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
                    Button(action: {
                        prevStep()
                    }) {
                        Text("< Prev")
                    }
                    .font(.title)
                    .buttonStyle(PrimaryButtonStyle())
                    Spacer()
                    Button(action: {
                        nextStep()
                    }) {
                        Text("Next >")
                    }
                    .font(.title)
                    .buttonStyle(PrimaryButtonStyle())
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
                    Text("Step 1")
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
            Instruction(instruction: "Preheat stove top for 10 minutes.", timer: 0)
        ]
    ))
}
