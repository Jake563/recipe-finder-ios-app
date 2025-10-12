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
func loadRecipe() -> RecipeOfTheDay? {
    do {
        let container = try makeSharedContainer()
        let recipes = try container.mainContext.fetch(FetchDescriptor<RecipeOfTheDay>().self)
        return recipes.randomElement()
    } catch {
        print("Failed to load recipes in widget: \(error)")
        return nil
    }
}

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), emoji: "😀", recipe: nil)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), emoji: "😀", recipe: nil)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, emoji: "😀", recipe: nil)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }

//    func relevances() async -> WidgetRelevances<Void> {
//        // Generate a list containing the contexts this widget is relevant in.
//    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let emoji: String
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
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

#Preview(as: .systemSmall) {
    DailyRecipeWidget()
} timeline: {
    SimpleEntry(date: .now, emoji: "😀", recipe: nil)
    SimpleEntry(date: .now, emoji: "🤩", recipe: nil)
}
