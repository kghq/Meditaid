//
//  Stopwatch.swift
//  Meditaid
//
//  Created by Krzysztof Garmulewicz on 01/12/2025.
//

import ActivityKit
import Foundation
import Observation

@Observable
class TimerManager {
    
    // Settings
    var settings: Settings
    var showingSettings = false
    
    // Clock
    var isRunning = false
    var hasStarted = false
    
    var sessionDates: [Date]? {
        didSet {
            guard let sessionDates else { return }
            if sessionDates.count % 2 != 0 {
                pauses = []
                for i in stride(from: 1, to: sessionDates.count - 1, by: 2) {
                    let pause = sessionDates[i + 1].timeIntervalSince(sessionDates[i])
                    pauses.append(pause)
                }
            }
        }
    }
    
    var pauses = [TimeInterval]()
    
    var compoundedPauses: TimeInterval {
        var compPauses = TimeInterval.zero
        for pause in pauses {
            compPauses += pause
        }
        return compPauses
    }
    
    // Display
    var timerCountingRange: Range<Date> {
        guard let startTime = sessionDates?.first else { return Date.now..<Date.distantFuture }
        
        let adjustedStartDate = startTime.addingTimeInterval(compoundedPauses)
        
        if isRunning {
            return adjustedStartDate..<Date.distantFuture
        } else {
            return Date.now + startTime.timeIntervalSince(sessionDates?.last ?? .now) + compoundedPauses..<Date.distantFuture
        }
    }

    // Healthkit
    var healthKitManager = HealthKitManager()
    
    // ActivityKit
    private var activity: Activity<TimerAttributes>? = nil
    
    // Hiding Status Bar
    var hideStatusBarOnTap = false
    var statusBarHidden: Bool {
        if hasStarted {
            return !hideStatusBarOnTap
        } else {
            return hideStatusBarOnTap
        }
    }
    
    // Start
    func start() {
        
        guard !isRunning else { return }
        
        sessionDates == nil ? sessionDates = [.now] : sessionDates?.append(.now)
        
        // ActivityKit
        if !hasStarted {
            let attributes = TimerAttributes()
            let initialState = TimerAttributes.ContentState(startDate: .now, pauses: pauses, isRunning: true)
            let content = ActivityContent(state: initialState, staleDate: nil)
            print("test2")
            do {
                activity = try Activity.request(attributes: attributes, content: content, pushType: nil)
            } catch {
                print(error.localizedDescription)
                print("test")
            }
        } else {
            Task {
                let updatedState = TimerAttributes.ContentState(startDate: sessionDates?[0] ?? .now, pauses: pauses, isRunning: true)
                await activity?.update(ActivityContent<TimerAttributes.ContentState>(state: updatedState, staleDate: nil))
            }
        }
        
        hasStarted = true
        isRunning = true
    }
    
    // Pause
    func pause() {
        
        guard isRunning else { return }
        
        sessionDates?.append(.now)
        
        // ActivityKit
        Task {
            let updatedState = TimerAttributes.ContentState(startDate: sessionDates?[0] ?? .now, pauses: pauses, isRunning: false)
            await activity?.update(ActivityContent<TimerAttributes.ContentState>(state: updatedState, staleDate: nil))
        }
        
        isRunning = false
    }

    // End
    func end() {
        
        guard hasStarted else { return }
        
        // HealthKit
        if let sessionDates = sessionDates {
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
            let finalState = TimerAttributes.ContentState(startDate: sessionDates?[0] ?? .now, pauses: pauses, isRunning: false)
            await activity?.end(ActivityContent(state: finalState, staleDate: nil), dismissalPolicy: .immediate)
        }
        
        sessionDates = nil
        
        isRunning = false
        hasStarted = false
    }
    
    // Reset: end with no HealthKit log
    func reset() {
        sessionDates = nil
        
        isRunning = false
        hasStarted = false
    }
    
    // Toggle Settings
    func toggleSettings() {
        showingSettings.toggle()
        hideStatusBarOnTap = false
    }
    
    init() {
        do {
            try settings = LoadSave.load(from: "settings.json")
        } catch {
            settings = Settings()
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
