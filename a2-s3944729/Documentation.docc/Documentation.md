# ``a2_s3944729``

This app is called LeftOvers. It enables users to discover cooking recipes that can be made with a list of ingredients they own.

## Overview

This app features:
- Adding, editing and deleting ingredients.
- Finding recipes based on a list of ingredients.
- Simple step-by-step instruction process on how to make a recipe dish. 
- Timers on time-based instructions to save the user from manually setting the timer.
- AI-generated instruction clarification in case the user gets confused on an instruction step.
- Saving recipes to favourites.
- Account sign-up, sign-in and sign-out.
- An Intelligent Personal Assistant that can perform operations like adding and editing ingredients.
- Widget that suggests recipes a user can make.

## Topics

### Models

- ``Ingredient``
- ``IngredientType``
- ``Recipe``
- ``SavedRecipe``
- ``StepClarification``
- ``StoredIngredient``

### Protocols

- ``FirebaseAuthServiceProtocol``
- ``NetworkSession``

### Services

- ``AiService``
- ``AuthService``
- ``IngredientService``
- ``IngredientTypeService``
- ``IntelligentAssistantService``
- ``RecipeService``
- ``SavedRecipesService``
- ``SpeechToTextService``

### Views

- ``AccountView``
- ``AppLogoLayout``
- ``ContentView``
- ``IngredientDetailsView``
- ``IngredientsView``
- ``IntroductionView``
- ``MainView``
- ``NewIngredientView``
- ``PrimaryButtonStyle``
- ``RecipeInfoView``
- ``RecipeInstructionsView``
- ``RecipesView``
- ``SavedRecipesView``
- ``StepClarificationView``
- ``ToastNotificationService``

### Shared
Common things that both the app and widgets need.

- ``Instruction``
- ``RecentRecipe``
- ``RequiredIngredient``
