# ``a2_s3944729``

This app is called LeftOvers. It allows users to discover cooking recipes that can be made with a list of ingredients they own.

## Overview

This app features:
- Adding, editing and deleting ingredients.
- Finding recipes based on a list of ingredients.
- Simple step-by-step instruction process on how to make a recipe dish. 
- Timers on time-based instructions to save the user from manually setting the timer.
- AI-generated instruction clarification in case the user gets confused on an instruction step.
- Saving recipes to favourites.
- Account sign-up, sign-in and sign-out.

## Topics

### Models

- ``AllIngredients``
- ``Ingredient``
- ``IngredientType``
- ``Instruction``
- ``Recipe``
- ``RequiredIngredient``
- ``SavedRecipe``
- ``StepClarification``
- ``StoredIngredient``

### Protocols

- ``FirebaseAuthService``
- ``NetworkSession``

### Services

- ``AiService``
- ``AuthService``
- ``IngredientService``
- ``SavedRecipesService``

### Views

- ``AccountView``
- ``AppLogoLayout``
- ``ContentView``
- ``IngredientDetailsView``
- ``IngredientsView``
- ``MainView``
- ``NewIngredientView``
- ``PrimaryButtonStyle``
- ``RecipeInfoView``
- ``RecipeInstructionsView``
- ``RecipesView``
- ``SavedRecipesView``
- ``StepClarificationView``
