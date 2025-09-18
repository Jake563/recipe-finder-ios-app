//
//  MainView.swift
//  a2-s3944729
//
//  View that allows the ingredients, recipes and saved recipes views to be navigated to.
//
//  Created by Jake Parkinson on 21/8/2025.
//

import SwiftUI
import SwiftData

class IngredientStore: ObservableObject {
    @Published var hasIngredientChanged: Bool = true
    @Published var newIngredientAdded: Bool = false
}

struct MainView: View {
    @StateObject private var ingredientStore = IngredientStore()

    var body: some View {
        TabView {
            Tab("Ingredients", systemImage: "refrigerator") {
                IngredientsView()
            }

            Tab("Recipes", systemImage: "note.text") {
                RecipesView()
            }

            Tab("Saved", systemImage: "heart") {
                SavedRecipesView()
            }
            
            Tab("Account", systemImage: "person.crop.circle") {
                AccountView()
            }
        }.environmentObject(ingredientStore)
    }
}

#Preview {
    MainView()
}
