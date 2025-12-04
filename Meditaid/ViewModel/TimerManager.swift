//
//  Stopwatch.swift
//  Meditaid
//
//  Created by Krzysztof Garmulewicz on 01/12/2025.
//

import Foundation
import Observation

@Observable
class TimerManager {
    
    // Clock & Settings
    var clock: ClockModel
	
	private var task: Task<Void, Never>?
	private let clockTicker = ContinuousClock()

    // Healthkit
    var healthKitManager = HealthKitManager()
    
    // AppIntents & ActivityKit
    var activityKitManager = ActivityKitManager()
    
    // Start
    func start() {
        
        guard !clock.isRunning else { return }
        
        clock.sessionDates == nil ? clock.sessionDates = [.now] : clock.sessionDates?.append(.now)
		
		// End when timer is up
		var durationRemaining = clock.timerDuration
		task = Task {
			while !Task.isCancelled {
				try? await clockTicker.sleep(for: .seconds(1))
				durationRemaining -= 1
				if durationRemaining == -1 {
					end()
				}
			}
		}
        
        // ActivityKit
//        if !clock.hasStarted {
//            activityKitManager.startActivity(startDate: .now, pauses: clock.pauses, isRunning: true)
//        } else {
//            activityKitManager.updateActivity(startDate: clock.sessionDates?[0] ?? .now, pauses: clock.pauses, isRunning: true)
//        }
        
        clock.hasStarted = true
        clock.isRunning = true
        
        save()
    }
    
    // Pause
    func pause() {
        
        guard clock.isRunning else { return }
        
        clock.sessionDates?.append(.now)
        
        // ActivityKit
        // activityKitManager.updateActivity(startDate: clock.sessionDates?[0] ?? .now, pauses: clock.pauses, isRunning: false)
        
        clock.isRunning = false
        
        save()
    }

    // End
    func end() {
        
        guard clock.hasStarted else { return }
        
        // HealthKit
        healthKitManager.saveMindfulSession(sessionDates: clock.sessionDates)
        
        // ActivityKit
        // activityKitManager.endActivity(startDate: clock.sessionDates?[0] ?? .now, pauses: clock.pauses, isRunning: false)
        
        clock.sessionDates = nil
		
		// Timer
		clock.elapsedIntervals = []
        
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
    
    func save() {
        LoadSave.save(clock, to: "clock.json")
    }
    
	init(clock: ClockModel) {
		self.clock = clock
	}
		
//        do {
//            try clock = LoadSave.load(from: "clock.json")
//        } catch {
//            print("Failed to load clock. Default.")
//			clock = ClockModel(mode: .timer) //change to zen after debugging
//        }
//    }
}
