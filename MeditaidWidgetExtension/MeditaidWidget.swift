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
        SimpleEntry(date: Date(), text1: "You Got This App To Meditate", text2: "Do That.")
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        let entry = SimpleEntry(date: Date(), text1: "You Got This App To Meditate", text2: "Do That.")
        completion(entry)
    }
    
    // The brain of the Widget
    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> Void) {
        var entries: [SimpleEntry] = [] // this is the timeline. array of data
        let entry = SimpleEntry(date: Date(), text1: "You Got This App To Meditate", text2: "Do That.")
        
        // Generate a timeline
        // let currentDate = Date()
        // for ... append to entries
        entries = [entry]
        
        let timeline = Timeline(entries: entries, policy: .never)
        completion(timeline)
    }
}

// A building block for timeline
struct SimpleEntry: TimelineEntry {
    let date: Date
    var text1: String
    var text2: String
}

struct MeditaidWidgetView: View {
    var entry: SimpleEntry
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                // Text("Last Time, You Meditated For 10 Minutes.")
                Text(entry.text1)
                    .foregroundStyle(.white)
                    .font(.headline)
                    .fontWeight(.semibold)
                Spacer()
                //Text("Do That Again.")
                Text(entry.text2)
                    .foregroundStyle(.white)
                // .font(.title3)
                    .fontWeight(.heavy)
            }
            Spacer()
        }
        .containerBackground(.black.gradient, for: .widget)
    }
}

struct MeditaidWidget: Widget {
    let kind: String = "MeditaidWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            MeditaidWidgetView(entry: entry)
        }
        .configurationDisplayName("Meditaid Widget")
        .description("A Very Simple Reminder To Meditate.")
        .supportedFamilies([.systemSmall])
    }
}

#Preview(as: .systemSmall, widget: {
    MeditaidWidget()
}, timeline: {
    SimpleEntry(date: Date(), text1: "You Got This App To Meditate", text2: "Do That.")
    // SimpleEntry(date: date.addingTimeInterval(60), text: "Good Bye!")
})

//extension DateComponentsFormatter {
//    static let localizedDaysFormatter: DateComponentsFormatter = {
//        let formatter = DateComponentsFormatter()
//        formatter.allowedUnits = [.day] // Only format days
//        formatter.unitsStyle = .full // Use full words ("days" instead of "d")
//        formatter.maximumUnitCount = 1 // Only show one unit (days, even if it's over a month)
//        formatter.allowsFractionalUnits = false // Do not show partial days
//        return formatter
//    }()
//}


