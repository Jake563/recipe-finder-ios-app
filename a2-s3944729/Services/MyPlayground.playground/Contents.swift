import UIKit

print("running")
Task {
    let stepClarifcation = await AiService.clarifyRecipeStep(instruction: Instruction(instruction: "Mix all ingredients in a bowl", timer: 0))
    print(stepClarifcation)
}
