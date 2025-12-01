//
//  Stopwatch.swift
//  Meditaid
//
//  Created by Krzysztof Garmulewicz on 01/12/2025.
//

import ActivityKit
import Foundation
import Observation
import SwiftUI

@Observable
class TimerManager {
    
    // Settings
    var settings: Settings
    var showingSettings = false
    
    // Clock
    var controlDate = Date.now
    var compoundedRuns = TimeInterval()
    var singleRun = TimeInterval()
    var startTapTime = Date()
    var isRunning = false
    var hasStarted = false
    
    // Display
    var timerCountingRange: Range<Date> {
        if isRunning {
            return (controlDate + compoundedRuns)..<Date.distantFuture
        } else {
            return (Date.now + compoundedRuns)..<Date.distantFuture
        }
    }

    // Healthkit
    var healthKitManager = HealthKitManager()
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
    
    // ActivityKit
    private var activity: Activity<TimerAttributes>? = nil
    var pauses = [TimeInterval]()
    
    // Hiding Status Bar
    var hideStatusBarOnTap = false
    var autoHide: Task<Void, Never>? = nil
    var isStatusBarHidden: Bool {
        if hasStarted {
            return !hideStatusBarOnTap
        } else {
            return hideStatusBarOnTap
        }
    }
    
    let buttonHaptics = UIImpactFeedbackGenerator(style: .medium)
    
    // Start
    func start() {
        
        guard !isRunning else { return }
        
        isRunning = true
        hasStarted = true
        
        controlDate = .now
        startTapTime = .now
        
        // Look and Feel
        buttonHaptics.impactOccurred()
        
        // HealthKit
        sessionDates == nil ? sessionDates = [.now] : sessionDates?.append(.now)
        
        // ActivityKit
        if !hasStarted {
            let attributes = TimerAttributes()
            let initialState = TimerAttributes.ContentState(startDate: .now, pauses: pauses, isRunning: true)
            let content = ActivityContent(state: initialState, staleDate: nil)
            activity = try? Activity.request(attributes: attributes, content: content, pushType: nil)
        } else {
            Task {
                let updatedState = TimerAttributes.ContentState(startDate: sessionDates?[0] ?? .now, pauses: pauses, isRunning: true)
                await activity?.update(ActivityContent<TimerAttributes.ContentState>(state: updatedState, staleDate: nil))
            }
        }
    }
    
    // Pause
    func pause() {
        
        guard isRunning else { return }
        
        isRunning = false
        singleRun = startTapTime.timeIntervalSinceNow
        compoundedRuns += singleRun
        
        // Look and Feel
        buttonHaptics.impactOccurred()
        autoHide?.cancel()
        handleButtonHide()
        
        // HealthKit
        sessionDates?.append(.now)
        
        // ActivityKit
        Task {
            let updatedState = TimerAttributes.ContentState(startDate: sessionDates?[0] ?? .now, pauses: pauses, isRunning: false)
            await activity?.update(ActivityContent<TimerAttributes.ContentState>(state: updatedState, staleDate: nil))
        }
    }

    // End
    func end() {
        
        controlDate = .now
        compoundedRuns = TimeInterval()
        hasStarted = false
        isRunning = false
        
        // Look and Feel
        buttonHaptics.impactOccurred()
        autoHide?.cancel()
        hideStatusBarOnTap = false
        
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
        sessionDates = nil
        
        // ActivityKit
        Task {
            let finalState = TimerAttributes.ContentState(startDate: sessionDates?[0] ?? .now, pauses: pauses, isRunning: false)
            await activity?.end(ActivityContent(state: finalState, staleDate: nil), dismissalPolicy: .immediate)
        }
    }
    
    // Reset: end with no HealthKit log
    func reset() {
        controlDate = .now
        compoundedRuns = TimeInterval()
    }
    
    // Toggle Settings
    func toggleSettings() {
        showingSettings.toggle()
        hideStatusBarOnTap = false
    }
    
    // Hiding StatusBar
    func handleButtonHide() {
        hideStatusBarOnTap = false
    }
    
    func handleScreenTap() {
        autoHide?.cancel()
        
        if hasStarted {
            withAnimation(.default) {
                hideStatusBarOnTap.toggle()
            }
            autoHide = Task {
                do {
                    try await Task.sleep(for: .seconds(3))
                    
                    guard !Task.isCancelled else { return }
                    
                    withAnimation(.default) {
                        hideStatusBarOnTap.toggle()
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        } else {
            withAnimation(.default) {
                hideStatusBarOnTap.toggle()
            }
        }
    }
    
    init() {
        do {
            try settings = LoadSave.load(from: "settings.json")
        } catch {
            print(error.localizedDescription)
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
