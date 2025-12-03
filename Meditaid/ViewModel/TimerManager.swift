//
//  Stopwatch.swift
//  Meditaid
//
//  Created by Krzysztof Garmulewicz on 01/12/2025.
//

import ActivityKit
import AppIntents
import Foundation
import Observation

@Observable
class TimerManager {
    
    // Clock & Settings
    var clock: ClockModel
    // var settings: Settings settings not needed?
    
    var showingSettings = false

    // Healthkit
    var healthKitManager = HealthKitManager()
    
    // AppIntents & ActivityKit
    static let shared = TimerManager()
    private var activity: Activity<TimerAttributes>? = nil
    
    // Hiding Status Bar
    var hideStatusBarOnTap = false
    var statusBarHidden: Bool {
        if clock.hasStarted {
            return !hideStatusBarOnTap
        } else {
            return hideStatusBarOnTap
        }
    }
    
    // Start
    func start() {
        
        guard !clock.isRunning else { return }
        
        clock.sessionDates == nil ? clock.sessionDates = [.now] : clock.sessionDates?.append(.now)
        
        // ActivityKit
        if !clock.hasStarted {
            let attributes = TimerAttributes()
            let initialState = TimerAttributes.ContentState(startDate: .now, pauses: clock.pauses, isRunning: true)
            let content = ActivityContent(state: initialState, staleDate: nil)
            do {
                activity = try Activity.request(attributes: attributes, content: content, pushType: nil)
            } catch {
                print(error.localizedDescription)
            }
        } else {
            Task {
                let updatedState = TimerAttributes.ContentState(startDate: clock.sessionDates?[0] ?? .now, pauses: clock.pauses, isRunning: true)
                await activity?.update(ActivityContent<TimerAttributes.ContentState>(state: updatedState, staleDate: nil))
            }
        }
        
        clock.hasStarted = true
        clock.isRunning = true
        
        save()
    }
    
    // Pause
    func pause() {
        
        guard clock.isRunning else { return }
        
        clock.sessionDates?.append(.now)
        
        // ActivityKit
        Task {
            let updatedState = TimerAttributes.ContentState(startDate: clock.sessionDates?[0] ?? .now, pauses: clock.pauses, isRunning: false)
            await activity?.update(ActivityContent<TimerAttributes.ContentState>(state: updatedState, staleDate: nil))
        }
        
        clock.isRunning = false
        
        save()
    }

    // End
    func end() {
        
        guard clock.hasStarted else { return }
        
        // HealthKit
        if let sessionDates = clock.sessionDates {
            for i in stride(from: 0, to: sessionDates.count, by: 2) { // or to: sessionDates.count - 1, then no guard needed
                guard i + 1 < sessionDates.count else { break } // skips the last date with no pair
                let startDate = sessionDates[i]
                let endDate = sessionDates[i + 1]
                let duration = Int(endDate.timeIntervalSince(startDate) / 60.0) // Minutes
                if duration > 0 && duration < 720 {
                    healthKitManager.saveMindfulSession(minutes: duration, startDate: startDate, endDate: endDate)
                }
            }
        }
        
        // ActivityKit
        Task {
            let finalState = TimerAttributes.ContentState(startDate: clock.sessionDates?[0] ?? .now, pauses: clock.pauses, isRunning: false)
            await activity?.end(ActivityContent(state: finalState, staleDate: nil), dismissalPolicy: .immediate)
        }
        endAllLiveActivities()
        
        clock.sessionDates = nil
        
        clock.isRunning = false
        clock.hasStarted = false
        
        save()
    }
    
    // Reset: end with no HealthKit log
    func reset() {
        clock.sessionDates = nil
        
        clock.isRunning = false
        clock.hasStarted = false
        
        save()
    }
    
    // Toggle Settings
    func toggleSettings() {
        showingSettings.toggle()
        hideStatusBarOnTap = false
    }
    
    func save() {
        LoadSave.save(clock, to: "clock.json")
    }
    
    init() {
        do {
            try clock = LoadSave.load(from: "clock.json")
            // try settings = LoadSave.load(from: "settings.json")
        } catch {
            print("Failed to load clock. Default.")
            clock = ClockModel()
            // settings = Settings()
        }
    }
    
//    TODO: - Schema Migration
//    // Schema migration
//    static func migrate(_ settingsToMigrate: Settings) {
//        if settingsToMigrate.schemaVersion == nil {
//            settingsToMigrate.intervalOptions = [.seconds(5), .seconds(300), .seconds(600), .seconds(900), .seconds(1800), .seconds(2700), .seconds(3600)]
//            settingsToMigrate.schemaVersion = 1
//        }
//    }
}

extension TimerManager {
    func endOldActivities() {
        guard let currentActivityID = self.activity?.id else {
            // endAllActivities()
            return
        }
        
        Task {
            let allActivities = Activity<TimerAttributes>.activities
            for activity in allActivities {
                if activity.id != currentActivityID {
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
