//
//  DailyRecipeWidget.swift
//  DailyRecipeWidget
//
//  Created by Jake Parkinson on 28/9/2025.
//

import WidgetKit
import SwiftUI
import SwiftData

@MainActor
func getRecipes() -> [RecipeOfTheDay] {
    do {
        let container = try makeSharedContainer()
        let recipes = try container.mainContext.fetch(FetchDescriptor<RecipeOfTheDay>().self)
        return recipes
    } catch {
        print("Failed to load recipes in widget: \(error)")
        return []
    }
}

struct Provider: @preconcurrency TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), recipe: nil)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), recipe: nil)
        completion(entry)
    }

    @MainActor func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        let recipes = getRecipes()

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for recipeIndex in 0..<recipes.count {
            let hourOffset = recipeIndex
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, recipe: recipes[recipeIndex])
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let recipe: RecipeOfTheDay?
}

struct DailyRecipeWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            if entry.recipe != nil {
                Text("You can make")
                Text(entry.recipe!.name)
                Text(entry.recipe!.estimatedTime)
            } else {
                Text("No daily recipe available.")
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
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                DailyRecipeWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("Recipe Suggestions")
        .description("These are recipes you can make with your ingredients.")
    }
}

#Preview(as: .systemSmall) {
    DailyRecipeWidget()
} timeline: {
    SimpleEntry(date: .now, recipe: RecipeOfTheDay(
        name: "Test Recipe",
        estimatedTime: "40 minutes",
        ingredients: [],
        instructions: []
    ))
    SimpleEntry(date: .now, recipe: RecipeOfTheDay(
        name: "Test Recipe 2",
        estimatedTime: "20 minutes",
        ingredients: [],
        instructions: []
    ))
}
