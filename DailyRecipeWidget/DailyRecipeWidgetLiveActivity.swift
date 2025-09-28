//
//  DailyRecipeWidgetLiveActivity.swift
//  DailyRecipeWidget
//
//  Created by Jake Parkinson on 28/9/2025.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct DailyRecipeWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct DailyRecipeWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: DailyRecipeWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension DailyRecipeWidgetAttributes {
    fileprivate static var preview: DailyRecipeWidgetAttributes {
        DailyRecipeWidgetAttributes(name: "World")
    }
}

extension DailyRecipeWidgetAttributes.ContentState {
    fileprivate static var smiley: DailyRecipeWidgetAttributes.ContentState {
        DailyRecipeWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: DailyRecipeWidgetAttributes.ContentState {
         DailyRecipeWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: DailyRecipeWidgetAttributes.preview) {
   DailyRecipeWidgetLiveActivity()
} contentStates: {
    DailyRecipeWidgetAttributes.ContentState.smiley
    DailyRecipeWidgetAttributes.ContentState.starEyes
}
