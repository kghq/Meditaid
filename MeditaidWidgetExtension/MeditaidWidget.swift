//
//  MeditaidWidget.swift
//  Meditaid
//
//  Created by Krzysztof Garmulewicz on 02/12/2025.
//

import SwiftUI
import WidgetKit

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), text: "Hello!")
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        
    }
    
    // The brain of the Widget
    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> Void) {
        // var entires: [SimpleEntry] = [] // this is the timeline. array of data
        
        // Generate a timeline
        // let currentDate = Date()
        // for ... append to entries
        
        // let timeline = Timeline(entries: entires, policy: .never)
    }
}

// A building block for timeline
struct SimpleEntry: TimelineEntry {
    let date: Date
    var text: String
}

struct MeditaidWidgetView: View {
    var entry: SimpleEntry
    
    var body: some View {
        Text(entry.text)
    }
}

struct MeditaidWidget: Widget {
    let kind: String = "MeditaidWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            MeditaidWidgetView(entry: entry)
        }
        .configurationDisplayName("MeditaidWidget")
        .description("A reminder to meditate.")
    }
}

struct MeditaidWidget_Previews: PreviewProvider {
    static var previews: some View {
        return MeditaidWidgetView(entry: SimpleEntry(date: Date(), text: "Hello!"))
    }
}
