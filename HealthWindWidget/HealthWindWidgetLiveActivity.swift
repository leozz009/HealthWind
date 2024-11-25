//
//  HealthWindWidgetLiveActivity.swift
//  HealthWindWidget
//
//  Created by Fatima Alonso on 11/24/24.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct HealthWindWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct HealthWindWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: HealthWindWidgetAttributes.self) { context in
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

extension HealthWindWidgetAttributes {
    fileprivate static var preview: HealthWindWidgetAttributes {
        HealthWindWidgetAttributes(name: "World")
    }
}

extension HealthWindWidgetAttributes.ContentState {
    fileprivate static var smiley: HealthWindWidgetAttributes.ContentState {
        HealthWindWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: HealthWindWidgetAttributes.ContentState {
         HealthWindWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: HealthWindWidgetAttributes.preview) {
   HealthWindWidgetLiveActivity()
} contentStates: {
    HealthWindWidgetAttributes.ContentState.smiley
    HealthWindWidgetAttributes.ContentState.starEyes
}
