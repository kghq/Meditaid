//
//  MeditaidWidgetExtensionLiveActivity.swift
//  MeditaidWidgetExtension
//
//  Created by Krzysztof Garmulewicz on 01/12/2025.
//

import ActivityKit
import SwiftUI
import WidgetKit

struct TimerActivityConfiguration: Widget {
    var body: some WidgetConfiguration {
        
        ActivityConfiguration(for: TimerAttributes.self) { context in
            // Lock screen/banner UI goes here
            HStack {
                if context.state.isRunning {
                    Text(timerInterval: context.state.startDateAdjusted...Date.distantFuture, countsDown: false)
                        .monospacedDigit()
                        .foregroundStyle(.white)
                        .font(.largeTitle)
                        .bold()
                        .contentTransition(.numericText())
                        .animation(.spring(duration: 0.2), value: context.state.startDateAdjusted)
                } else {
                    Text(timerInterval: context.state.startDateAdjusted...Date.distantFuture, pauseTime: .now, countsDown: false)
                        .monospacedDigit()
                        .foregroundStyle(.white)
                        .font(.largeTitle)
                        .bold()
                }
                Spacer()
                HStack {
                    VStack {
                        Circle()
                            .frame(maxWidth: 50)
                            .foregroundStyle(.red)
                            .opacity(0.4)
                    }
                    VStack {
                        Circle()
                            .frame(maxWidth: 50)
                            .foregroundStyle(.green)
                            .opacity(0.4)
                    }
                }
            }
            .preferredColorScheme(.dark)
            .padding()
            .activityBackgroundTint(.black)

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
//                DynamicIslandExpandedRegion(.center) {
//                    HStack {
////                        Text(timerInterval: startDate...endDate, countsDown: false)
////                            .font(.largeTitle)
////                            .monospacedDigit()
////                            .bold()
////                        Spacer()
//                    }
//                }
//                DynamicIslandExpandedRegion(.bottom) {
//                    HStack {
////                        Text(timerInterval: startDate...endDate, countsDown: false)
////                            .font(.largeTitle)
////                            .monospacedDigit()
////                            .bold()
////                        Spacer()
//                    }
//                }
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

#Preview(as: .dynamicIsland(.compact), using: TimerAttributes.init()) {
    TimerActivityConfiguration()
} contentStates: {
    TimerAttributes.ContentState(startDate: (.now - 71), pauses: [], isRunning: false)
    TimerAttributes.ContentState(startDate: (.now - 300), pauses: [2, 8, 6], isRunning: true)
}

#Preview(as: .content, using: TimerAttributes()) {
    TimerActivityConfiguration()
} contentStates: {
    TimerAttributes.ContentState(startDate: .now, pauses: [], isRunning: false)
}
