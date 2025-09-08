//
//  RecipeInfoView.swift
//  a2-s3944729
//
//  Created by Jake Parkinson on 24/8/2025.
//

import SwiftUI

struct RecipeInfoView: View {
    @Environment(\.dismiss) private var dismiss
    
    let recipe: Recipe
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Image(systemName: "clock")
                    Text("20 minutes")
                        .font(.title2)
                    Spacer()
                }
                .padding(.horizontal)
                Spacer(minLength: 30)
                HStack {
                    Text("Ingredients")
                        .font(.title2)
                    Spacer()
                }
                .padding(.horizontal)
                List(recipe.ingredients, id: \.self) { ingredient in
                    VStack {
                        HStack {
                            HStack {
                                Image("fruit")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 30, height: 30)
                                Text(ingredient)
                            }
                            Spacer()
                            Text("500mL")
                        }
                        Divider()
                    }
                }
                .listRowSpacing(5)
                .scrollContentBackground(.hidden)
                Button(action: {
                    print("View instructions")
                }) {
                    Text("View Instructions")
                        .frame(maxWidth: .infinity)
                        .font(.title)
                }
                .padding()
                .buttonStyle(PrimaryButtonStyle())
            }

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
                    Text(recipe.name)
                        .font(.title)
                }
            }
        }
    }
}

#Preview {
    RecipeInfoView(recipe: Recipe(
        name: "Test Recipe",
        ingredients: ["Egg", "Milk"],
        instructions: []
    ))
}
