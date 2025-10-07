//
//  IngredientDetailsView.swift
//  a2-s3944729
//
//  Created by Jake Parkinson on 21/8/2025.
//

import SwiftUI
import SwiftData

private let LITRE_MASS_UNITS = ["mL", "L"]
private let WEIGHT_MASS_UNITS = ["g", "kg"]
private let MAX_QUANTITY_CHARACTERS = 4

/// View that allows an ingredient to be added, edited or deleted.
struct IngredientDetailsView: View {
    @State private var enteredQuantity: String
    @State private var selectedMassUnit: String
    @State private var massUnitOptions: [String]
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    @EnvironmentObject private var ingredientStore: IngredientStore
    @EnvironmentObject private var toastNotificationService: ToastNotificationService

    @Query
    private var storedIngredients: [StoredIngredient]
    
    let ingredient: Ingredient
    let addingIngredient: Bool
    
    init(ingredient: Ingredient, addingIngredient: Bool) {
        self.ingredient = ingredient
        self.addingIngredient = addingIngredient
        self.enteredQuantity = String(ingredient.quantity)
        
        if ingredient.ingredientType.quantityUnit == QuantityUnit.litres {
            massUnitOptions = LITRE_MASS_UNITS
            selectedMassUnit = LITRE_MASS_UNITS[0]
        } else if ingredient.ingredientType.quantityUnit == QuantityUnit.weight {
            massUnitOptions = WEIGHT_MASS_UNITS
            selectedMassUnit = WEIGHT_MASS_UNITS[0]
        } else {
            massUnitOptions = []
            selectedMassUnit = ""
        }
    }
    
    /// Determines whether the new value for the quantity is allowed.
    private func allowQuantityValueChange(newValue: String) -> Bool {
        if newValue.isEmpty {
            // Empty values are allowed so the first digit can be changed.
            return true
        }
        let numberNewValue = Int(newValue)
        if numberNewValue == nil {
            // Non-integer values are not allowed.
            return false
        }
        
        if newValue.count > MAX_QUANTITY_CHARACTERS {
            // Character count exceeds max quantity characters.
            return false
        }
        return true
    }
    
    /// Removes the selected ingredient from the user's saved ingredients
    private func deleteIngredient() {
        for storedIngredient in storedIngredients {
            if storedIngredient.id == ingredient.storedIngredientID {
                context.delete(storedIngredient)
                try? context.save()
                break
            }
        }
        ingredientStore.hasIngredientChanged = true
        dismiss()
    }
    
    /// Updates the details of the selected ingredient
    private func saveIngredient() {
        let quantity = Int(enteredQuantity) ?? -1
        
        if quantity == -1 {
            return
        }
        
        for storedIngredient in storedIngredients {
            if storedIngredient.id == ingredient.storedIngredientID {
                storedIngredient.quantity = quantity
                storedIngredient.quantityMassUnit = selectedMassUnit
                try? context.save()
                break
            }
        }

        ingredientStore.hasIngredientChanged = true
        dismiss()
    }
    
    /// Adds the selected ingredient to the user's saved ingredients
    private func addIngredient() {
        let quantity = Int(enteredQuantity) ?? -1
        
        if quantity == -1 {
            return
        }
        

        let storedIngredient = StoredIngredient(
            quantity: quantity,
            quantityMassUnit: selectedMassUnit,
            ingredientTypeID: -1
        )
        
        // Get ingredient type id
        var index = 0
        for ingredient in AllIngredients.ingredients {
            if ingredient.name == self.ingredient.ingredientType.name {
                storedIngredient.ingredientTypeID = index
                break
            }
            index = index + 1
        }
        
        context.insert(storedIngredient)
        try? context.save()
        ingredientStore.hasIngredientChanged = true
        ingredientStore.newIngredientAdded = true
        
        toastNotificationService.displayNotification(message: "Ingredient Added!")
        dismiss()
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Text("Quantity:")
                    TextField("", text: $enteredQuantity).keyboardType(.numberPad)
                        .frame(width: 40, height: 34)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1)
                        )
                        .multilineTextAlignment(.center)
                        .onChange(of: enteredQuantity) { oldValue, newValue in
                            let changeAllowed = allowQuantityValueChange(newValue: newValue)
                            
                            if !changeAllowed {
                                enteredQuantity = oldValue
                            }
                        }
                    if !massUnitOptions.isEmpty {
                        Picker("Select a mass unit", selection: $selectedMassUnit) {
                            ForEach(massUnitOptions, id: \.self) { unit in
                                Text(unit)
                            }
                        }
                        .overlay(
                            RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1)
                        )
                    }
                    Spacer()
                }
                .padding()
                Spacer()
                if addingIngredient {
                    Button(action: addIngredient) {
                        Text("Add")
                            .frame(maxWidth:.infinity)
                            .font(.title)
                    }
                    .padding()
                    .buttonStyle(PrimaryButtonStyle())
                } else {
                    Button(action: saveIngredient) {
                        Text("Save")
                            .frame(maxWidth:.infinity)
                            .font(.title)
                    }
                    .padding()
                    .buttonStyle(PrimaryButtonStyle())
                }
       
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
                    Text(ingredient.ingredientType.name)
                        .font(.title)
                }
                if !addingIngredient {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: deleteIngredient) {
                            Image(systemName: "trash")
                                .foregroundColor(.black)
                        }
                    }
                }
            }
        }
        .onAppear() {
            if ingredient.quantityMassUnit != nil {
                selectedMassUnit = ingredient.quantityMassUnit!
            }
        }
    }
}

#Preview {
    IngredientDetailsView(ingredient: Ingredient(quantity: 1, quantityMassUnit: nil, ingredientType: IngredientType.init(name: "Test", icon: "misc", quantityUnit: QuantityUnit.litres), storedIngredientID: nil), addingIngredient: true)
}
