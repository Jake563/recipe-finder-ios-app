//
//  RecipeInstructionsView.swift
//  a2-s3944729
//
//  Created by Jake Parkinson on 9/9/2025
//

import SwiftUI

/// View that contains all the steps for a recipe, only showing one step at a time.
struct RecipeInstructionsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var currentInstruction: Instruction
    @State private var currentInstructionIndex: Int
    @State private var timeRemaining: Int = 0
    @State private var timerPaused = true
    @State private var timerLoopStopped = true
    @State private var instructionHelpShown: Bool = false
    @State private var clarificationLoaded: Bool = false
    
    private let ONE_SECOND: UInt64 = 1_000_000_000
    
    let recipe: Recipe
    
    /// Displays the next instruction step of the recipe
    private func nextStep() {
        if currentInstructionIndex == recipe.instructions.count - 1 {
            return
        }
        currentInstructionIndex = currentInstructionIndex + 1
        currentInstruction = recipe.instructions[currentInstructionIndex]
        initTimer()
        clarificationLoaded = false
    }
    
    /// Displays the previous instruction step of the recipe
    private func prevStep() {
        if currentInstructionIndex == 0 {
            return
        }
        currentInstructionIndex = currentInstructionIndex - 1
        currentInstruction = recipe.instructions[currentInstructionIndex]
        initTimer()
        clarificationLoaded = false
    }
    
    private func initTimer() {
        timerPaused = true
        timeRemaining = currentInstruction.timer
    }

    /// Makes the timer start counting down
    private func startTimer() {
        timerLoopStopped = false
        timerPaused = false
        Task {
            try? await Task.sleep(nanoseconds: ONE_SECOND)
            while timeRemaining > 0 && timerPaused == false {
                timeRemaining = timeRemaining - 1
                try? await Task.sleep(nanoseconds: ONE_SECOND)
            }
            timerLoopStopped = true
        }
    }
    
    private func pauseTimer() {
        timerPaused = true
    }
    
    private func getTimerText() -> String {
        if timerPaused {
            return "Start Timer"
        }
        return "Pause Timer"
    }
    
    /// Returns given seconds in timer-format. For example: 66 -> 01:06.
    private func getFormattedTime(seconds: Int) -> String {
        let formatter = DateComponentsFormatter()
        formatter.zeroFormattingBehavior = [.pad]
        formatter.unitsStyle = .positional

        if seconds >= 3600 {
            formatter.allowedUnits = [.hour, .minute, .second]
        } else {
            formatter.allowedUnits = [.minute, .second]
        }
        
        if let formattedTime = formatter.string(from: TimeInterval(seconds)) {
            return formattedTime
        }
        
        return "error"
    }
    
    init(recipe: Recipe) {
        self.recipe = recipe
        self.currentInstruction = recipe.instructions[0]
        self.currentInstructionIndex = 0
        initTimer()
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Text(currentInstruction.instruction)
                        .font(.title2)
                    Spacer()
                }
                Spacer()
                if currentInstruction.timer > 0 {
                    VStack {
                        HStack {
                            Image(systemName: "clock")
                                .font(.title2)
                            Text("\(getFormattedTime(seconds: timeRemaining))")
                                .font(.title2)
                        }
                        Button(action: {
                            if timerPaused {
                                if timerLoopStopped {
                                    startTimer()
                                }
                            } else {
                                pauseTimer()
                            }
                        }) {
                            Text(getTimerText())
                        }
                        .font(.title)
                        .buttonStyle(PrimaryButtonStyle())
                    }
                    Spacer()
                }
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
            .onAppear() {
                initTimer()
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
                        instructionHelpShown = true
                    }) {
                        Image(systemName: "questionmark.circle")
                            .foregroundColor(.black)
                    }
                }
            }
            .sheet(isPresented: $instructionHelpShown, content: { StepClarificationView(instruction: currentInstruction)
            })
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
            Instruction(instruction: "Preheat stove top for 10 minutes.", timer: 5),
            Instruction(instruction: "Crack eggs into pan.", timer: 0)
        ]
    ))
}
