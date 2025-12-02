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
                DynamicIslandExpandedRegion(.leading) {
                    VStack {
                        Spacer()
                        if context.state.isRunning {
                            Text(timerInterval: context.state.startDateAdjusted...Date.distantFuture, countsDown: false)
                                .monospacedDigit()
                                .font(.largeTitle)
                                .bold()
                                .contentTransition(.numericText())
                        } else {
                            Text(timerInterval: context.state.startDateAdjusted...Date.distantFuture, pauseTime: .now, countsDown: false)
                                .monospacedDigit()
                                .font(.largeTitle)
                                .bold()
                        }
                    }
                }
                DynamicIslandExpandedRegion(.trailing) {
                    HStack {
                        VStack {
                            Circle()
                                .frame(maxWidth: .infinity)
                                .foregroundStyle(.red)
                                .opacity(0.4)
                        }
                        VStack {
                            Circle()
                                .frame(maxWidth: .infinity)
                                .foregroundStyle(.green)
                                .opacity(0.4)
                        }
                    }
                }
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
            } minimal: {
                Image(systemName: "figure.mind.and.body")
            }
            .keylineTint(Color.orange)
        }
    }
}


struct LockScreenActivity: View {
    
    let context: ActivityViewContext<TimerAttributes>
    
    var body: some View {
        HStack {
            if context.state.isRunning {
                LiveActivityDisplayTimer(startDate: context.state.startDateAdjusted, endDate: .distantFuture, countsDown: false)
            } else {
                LiveActivityDisplayTimer(startDate: context.state.startDateAdjusted, endDate: .distantFuture, pauseTime: .now, countsDown: false)
            }
            
            Spacer()
            
            LockScreenActivityButton(type: "End", isRunning: context.state.isRunning)

        }
        .padding()
        .background(.white)
        .activitySystemActionForegroundColor(Color.red)
        .activityBackgroundTint(.green)
        // .keylineTint(Color.orange)
    }
}





struct LockScreenActivityButton: View {
    
    let type: String
    var isRunning: Bool = true
    
    var body: some View {
        VStack {
            Button(intent: PauseTimerIntent()) {
                Label("End", systemImage: "stop.fill")
                    .font(.caption)
                    .labelsHidden()
            }
            .tint(.red)
            .disabled(isRunning)
            .frame(maxWidth: .infinity)
            Button(intent: PauseTimerIntent()) {
                Label("Pause", systemImage: "pause")
                    .font(.caption)
                    .labelsHidden()
            }
            .tint(.blue)
            .frame(maxWidth: .infinity)
        }
        .frame(width: 100)
    }
}

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

#Preview("Dynamic Island", as: .dynamicIsland(.compact), using: TimerAttributes.init()) {
    TimerActivityConfiguration()
} contentStates: {
    TimerAttributes.ContentState(startDate: (.now - 143), pauses: [], isRunning: true)
//    TimerAttributes.ContentState(startDate: (.now - 300), pauses: [2, 8, 6], isRunning: true)
}

#Preview("Lock Screen", as: .content, using: TimerAttributes()) {
    TimerActivityConfiguration()
} contentStates: {
    TimerAttributes.ContentState(startDate: .now, pauses: [], isRunning: false)
}
