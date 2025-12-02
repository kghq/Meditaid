//
//  MeditaidWidgetExtensionLiveActivity.swift
//  MeditaidWidgetExtension
//
//  Created by Krzysztof Garmulewicz on 01/12/2025.
//

import AppIntents
import ActivityKit
import SwiftUI
import WidgetKit

struct TimerActivityConfiguration: Widget {
    var body: some WidgetConfiguration {
        
        ActivityConfiguration(for: TimerAttributes.self) { context in
            
            // Lock screen
            LockScreenActivity(context: context)

            // Dynamic Island
        } dynamicIsland: { context in
            DynamicIsland {
                
                // Expanded
                DynamicIslandExpandedRegion(.leading) {
                    HStack {
                        DynamicIslandExpandedLeading(context: context)
                    }
                }
                
                // Compact
            } compactLeading: {
                if context.state.isRunning {
                    Text(timerInterval: context.state.startDateAdjusted...Date.distantFuture, countsDown: false)
                        .monospacedDigit()
                        .bold()
                        .frame(maxWidth: 42, alignment: .leading)
                } else {
                    HStack {
                        Spacer()
                        Text(timerInterval: context.state.startDateAdjusted...Date.distantFuture, pauseTime: .now, countsDown: false)
                            .frame(maxWidth: 42, alignment: .leading)
                    }
                }
            } compactTrailing: {
                Image(systemName: "figure.mind.and.body")
                
                // Minimal
            } minimal: {
                Image(systemName: "figure.mind.and.body")
            }
        }
    }
}

// Lock Screen
struct LockScreenActivity: View {
    let context: ActivityViewContext<TimerAttributes>
    var body: some View {
        HStack {
            Spacer()
            if context.state.isRunning {
                LiveActivityDisplayTimer(startDate: context.state.startDateAdjusted, endDate: .distantFuture, countsDown: false)
            } else {
                LiveActivityDisplayTimer(startDate: context.state.startDateAdjusted, endDate: .distantFuture, pauseTime: .now, countsDown: false)
            }
        }
        .padding()
        .background(.black)
    }
}

// Dynamic Island Expanded
struct DynamicIslandExpandedLeading: View {
    let context: ActivityViewContext<TimerAttributes>
    var body: some View {
        VStack {
            Spacer()
            if context.state.isRunning {
                LiveActivityDisplayTimer(startDate: context.state.startDateAdjusted, endDate: .distantFuture, countsDown: false)
            } else {
                LiveActivityDisplayTimer(startDate: context.state.startDateAdjusted, endDate: .distantFuture, pauseTime: .now, countsDown: false)
            }
        }
    }
}

// Text Timer
struct LiveActivityDisplayTimer: View {
    
    let startDate: Date
    let endDate: Date
    var pauseTime: Date? = nil
    let countsDown: Bool
    
    var body: some View {
        Text(timerInterval: startDate...endDate, pauseTime: pauseTime, countsDown: false)
            .monospacedDigit()
            .foregroundStyle(.white)
            .font(.largeTitle)
            .bold()
    }
}

#Preview("Dynamic Island", as: .dynamicIsland(.expanded), using: TimerAttributes.init()) {
    TimerActivityConfiguration()
} contentStates: {
    TimerAttributes.ContentState(startDate: (.now - 143), pauses: [], isRunning: true)
    TimerAttributes.ContentState(startDate: (.now - 300), pauses: [2, 8, 6], isRunning: true)
}

#Preview("Lock Screen", as: .content, using: TimerAttributes()) {
    TimerActivityConfiguration()
} contentStates: {
    TimerAttributes.ContentState(startDate: .now, pauses: [], isRunning: false)
}
