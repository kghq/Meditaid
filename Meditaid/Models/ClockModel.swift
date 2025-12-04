//
//  Timekeeping.swift
//  Meditaid
//
//  Created by Krzysztof Garmulewicz on 03/12/2025.
//

import Foundation
import Observation

@Observable
class ClockModel: Codable {
	
	var mode: Mode
    
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
			} else {
				elapsedIntervals = []
				for i in stride(from: 0, to: sessionDates.count - 1, by: 2) {
					let oneEleapsed = sessionDates[i + 1].timeIntervalSince(sessionDates[i])
					elapsedIntervals.append(oneEleapsed)
				}
			}
        }
    }
	
	var elapsedIntervals = [TimeInterval]()
	var elapsed: TimeInterval {
		var compElapsed = TimeInterval.zero
		for oneElapsed in elapsedIntervals {
			compElapsed += oneElapsed
		}
		return compElapsed
	}
	
	// Zen
    var pauses = [TimeInterval]()
    var compoundedPauses: TimeInterval {
        var compPauses = TimeInterval.zero
        for pause in pauses {
            compPauses += pause
        }
        return compPauses
    }
	
	// Timer
	var timerDuration: TimeInterval = 600.0 {
		didSet { save() }
	}
    
    // Display
	var timerCountingRange: Range<Date> {
		
		var startTime = Date.now
		var adjustedStartDate = Date.now
		
		switch mode {
			
		case .zen:
			
			if let zenStartTime = sessionDates?.first {
				startTime = zenStartTime
			} else {
				return Date.now..<Date.distantFuture
			}
			
			adjustedStartDate = startTime.addingTimeInterval(compoundedPauses)
			
			if isRunning {
				return adjustedStartDate..<Date.distantFuture
			} else {
				let startDate = Date.now + startTime.timeIntervalSince(sessionDates?.last ?? .now) + compoundedPauses
				return startDate..<Date.distantFuture
			}
		case .timer:
			
			adjustedStartDate = startTime.addingTimeInterval(elapsed)
			
			if isRunning, let lastDate = sessionDates?.last {
				let endDate = lastDate.addingTimeInterval(timerDuration - elapsed)
				return lastDate..<endDate
			} else {
				let endDate = Date.now.addingTimeInterval(timerDuration - elapsed)
				return Date.now..<endDate
			}
		}
	}
	
	var isTimerFinished: Bool {
		// TODO: check if that works. If true, run timerManager.end()
		timerDuration == elapsed ? true : false
	}
	
	func save() {
		LoadSave.save(self, to: "clock.json")
	}
	
	init(mode: Mode) {
		self.mode = mode
	}
    
    // CodingKeys
    enum CodingKeys: String, CodingKey {
		case _mode = "mode"
        case _isRunning = "isRunning"
        case _hasStarted = "hasStarted"
        case _sessionDates = "sessionDates"
        case _pauses = "pauses"
    }
}
