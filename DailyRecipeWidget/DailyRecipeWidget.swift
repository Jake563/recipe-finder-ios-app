//
//  DailyRecipeWidget.swift
//  DailyRecipeWidget
//
//  Created by Jake Parkinson on 28/9/2025.
//

import WidgetKit
import SwiftUI
import SwiftData

struct Provider: TimelineProvider {
    @MainActor
    private func getRecipes() async -> [RecipeReference] {
        do {
            let container = try makeSharedContainer()
            let recipes = try container.mainContext.fetch(FetchDescriptor<RecentRecipe>().self)
            
            return recipes.map { recipe in
               RecipeReference(
                   name: recipe.name,
                   estimatedTime: recipe.estimatedTime
               )
            }
        } catch {
            print("Failed to load recipes in widget: \(error)")
            return []
        }
    }
    
    func placeholder(in context: Context) -> RecipeEntry {
        RecipeEntry(
            date: Date(),
            recipe: RecipeReference(
                name: "Loading...",
                estimatedTime: ""
            )
        )
    }

    func getSnapshot(in context: Context, completion: @escaping (RecipeEntry) -> ()) {
        let entry = RecipeEntry(
            date: Date(),
            recipe: RecipeReference(
                name: "Example Recipe",
                estimatedTime: "20 minutes"
            )
        )
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        print("Get Timeline invoked")
        Task { @MainActor in
            var entries: [RecipeEntry] = []
            let recipes = await getRecipes()
            print("No. recipes: \(recipes.count)")
            
            // Generate a timeline consisting of five entries an hour apart, starting from the current date.
            let currentDate = Date()
            for recipeIndex in 0..<recipes.count {
                let hourOffset = recipeIndex
                let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
                let entry = RecipeEntry(date: entryDate, recipe: recipes[recipeIndex])
                entries.append(entry)
            }
            let timeline = Timeline(entries: entries, policy: .atEnd)
            completion(timeline)
        }
    }
}

struct RecipeEntry: TimelineEntry {
    let date: Date
    let recipe: RecipeReference?
}

struct RecipeReference {
    let name: String
    let estimatedTime: String
}

struct DailyRecipeWidgetEntryView: View {
    var entry: RecipeEntry
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("You can make")
                .foregroundColor(.white)
            
            Text(entry.recipe!.name)
                .font(.title2)
                .bold()
                .foregroundColor(.white)
            
            HStack {
                Image(systemName: "clock")
                    .foregroundStyle(.white)
                Text("\(entry.recipe!.estimatedTime)")
                    .foregroundColor(.white)
            }
        }
    }
}


struct DailyRecipeWidget: Widget {
    let kind: String = "DailyRecipeWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                DailyRecipeWidgetEntryView(entry: entry)
                    .containerBackground(for: .widget) {
                        LinearGradient(
                            colors: [.pink, .purple],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    }
            } else {
                DailyRecipeWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .supportedFamilies([.systemSmall])
        .configurationDisplayName("Recipe Suggestions")
        .description("These are recipes you can make with your ingredients.")
    }
}

#Preview(as: .systemSmall) {
    DailyRecipeWidget()
} timeline: {
    RecipeEntry(date: .now, recipe: RecipeReference(
        name: "Choc-chip Cookies",
        estimatedTime: "40 minutes"
    ))
    RecipeEntry(date: .now, recipe: RecipeReference(
        name: "Test Recipe 2",
        estimatedTime: "20 minutes"
    ))
}
