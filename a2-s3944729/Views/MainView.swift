//
//  MainView.swift
//  a2-s3944729
//
//  Created by Jake Parkinson on 21/8/2025.
//

import SwiftUI
import SwiftData

class IngredientStore: ObservableObject {
    @Published var hasIngredientChanged: Bool = true
    @Published var newIngredientAdded: Bool = false
}

let INGREDIENTS_TAB_ID = 0
let RECIPES_TAB_ID = 1
let SAVED_RECIPES_TAB_ID = 2
let ACCOUNT_TAB_ID = 3

/// View that allows the ingredients, recipes and saved recipes views to be navigated to.
struct MainView: View {
    @StateObject private var ingredientStore = IngredientStore()
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            IngredientsView()
                .tabItem {
                    Label("Ingredients", systemImage: "refrigerator")
                }
                .tag(INGREDIENTS_TAB_ID)
            
            RecipesView(selectedTab: $selectedTab)
                .tabItem {
                    Label("Recipes", systemImage: "note.text")
                }
                .tag(RECIPES_TAB_ID)
            
            SavedRecipesView()
                .tabItem {
                    Label("Saved", systemImage: "heart")
                }
                .tag(SAVED_RECIPES_TAB_ID)

            AccountView()
                .tabItem {
                    Label("Account", systemImage: "person.crop.circle")
                }
                .tag(ACCOUNT_TAB_ID)
        }.environmentObject(ingredientStore)
    }
}

#Preview {
    MainView()
}
