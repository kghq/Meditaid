//
//  ActivityKitManager.swift
//  Meditaid
//
//  Created by Krzysztof Garmulewicz on 03/12/2025.
//

import ActivityKit
import Foundation

class ActivityKitManager {
    
    var activity: Activity<TimerAttributes>? = nil
    
    func startActivity(startDate: Date, pauses: [TimeInterval], isRunning: Bool) {
        let attributes = TimerAttributes()
        let initialState = TimerAttributes.ContentState(startDate: startDate, pauses: pauses, isRunning: isRunning)
        let content = ActivityContent(state: initialState, staleDate: nil)
        do {
            activity = try Activity.request(attributes: attributes, content: content, pushType: nil)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func updateActivity(startDate: Date, pauses: [TimeInterval], isRunning: Bool) {
        Task {
            let updatedState = TimerAttributes.ContentState(startDate: startDate, pauses: pauses, isRunning: isRunning)
            await activity?.update(ActivityContent<TimerAttributes.ContentState>(state: updatedState, staleDate: nil))
        }
    }
    
    func endActivity(startDate: Date, pauses: [TimeInterval], isRunning: Bool) {
        Task {
            let finalState = TimerAttributes.ContentState(startDate: startDate, pauses: pauses, isRunning: isRunning)
            await activity?.end(ActivityContent(state: finalState, staleDate: nil), dismissalPolicy: .immediate)
        }
        endAllLiveActivities()
    }
    
    func endAllLiveActivities() {
        Task {
            let allActivities = Activity<TimerAttributes>.activities
            
            for activity in allActivities {
                let finalState = TimerAttributes.ContentState(
                    startDate: Date.distantPast,
                    pauses: [],
                    isRunning: false
                )
                
                await activity.end(ActivityContent(state: finalState, staleDate: nil), dismissalPolicy: .immediate)
            }
        }
    }
}
