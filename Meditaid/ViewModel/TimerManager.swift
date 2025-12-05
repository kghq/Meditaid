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
	var settings: Settings
	
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
		if settings.mode == .timer {
			var durationRemaining = clock.timerDuration - clock.elapsed
			task = Task {
				while !Task.isCancelled {
					try? await clockTicker.sleep(for: .seconds(1))
					durationRemaining -= 1
					if durationRemaining <= -1 {
						end()
					}
					print(durationRemaining)
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
		
		task?.cancel()
        
        // ActivityKit
        // activityKitManager.updateActivity(startDate: clock.sessionDates?[0] ?? .now, pauses: clock.pauses, isRunning: false)
        
        clock.isRunning = false
        
        save()
    }

    // End
    func end() {
        
        guard clock.hasStarted else { return }
		
		task?.cancel()
        
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
    func cancel() {
        clock.sessionDates = nil
		
		task?.cancel()
		
		// ActivityKit
		// activityKitManager.endActivity(startDate: clock.sessionDates?[0] ?? .now, pauses: clock.pauses, isRunning: false)
		
		// Timer
		clock.elapsedIntervals = []
        
        clock.isRunning = false
        clock.hasStarted = false
        
        save()
    }
    
    func save() {
        LoadSave.save(clock, to: "clock.json")
    }
    
	init(clock: ClockModel, settings: Settings) {
		self.clock = clock
		self.settings = settings
	}
		
//        do {
//            try clock = LoadSave.load(from: "clock.json")
//        } catch {
//            print("Failed to load clock. Default.")
//			clock = ClockModel(mode: .timer) //change to zen after debugging
//        }
//    }
}
