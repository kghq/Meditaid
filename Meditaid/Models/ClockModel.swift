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
    
    // Clock
    var isRunning = false
    var hasStarted = false
//	var isFinished: Bool {
//		calculateTimeRemaining() <= 0
//	}
//    
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
	var elapsedIntervals = [TimeInterval]()
	var elapsed: TimeInterval {
		var compElapsed = TimeInterval.zero
		for oneElapsed in elapsedIntervals {
			compElapsed += oneElapsed
		}
		return compElapsed
	}
	var hours: TimeInterval = 0 {
		didSet { save() }
	}
	var minutes: TimeInterval = 900 {
		didSet { save() }
	}
	var timerDuration: TimeInterval {
		hours + minutes
	}
	
	// Display
	var zenCountingRange: Range<Date> {
		guard let startTime = sessionDates?.first else { return Date.now..<Date.distantFuture }
		let adjustedStartDate = startTime.addingTimeInterval(compoundedPauses)
		
		if isRunning {
			return adjustedStartDate..<Date.distantFuture
		} else {
			return Date.now + startTime.timeIntervalSince(sessionDates?.last ?? .now) + compoundedPauses..<Date.distantFuture
		}
	}
	var timerCountingRange: Range<Date> {
		if isRunning, let lastDate = sessionDates?.last {
			let endDate = lastDate.addingTimeInterval(timerDuration - elapsed)
			if lastDate > endDate {
				return endDate..<endDate
			}
			return lastDate..<endDate
		} else {
			let endDate = Date.now.addingTimeInterval(timerDuration - elapsed)
			return Date.now..<endDate
		}
	}
	
	func save() {
		LoadSave.save(self, to: "clock.json")
	}
	
	func calculateTimeRemaining() -> TimeInterval {
		let lastStartTime = sessionDates?.last ?? Date.now
		let targetEndTime = lastStartTime.addingTimeInterval(timerDuration - elapsed)
		let timeRemaining = targetEndTime.timeIntervalSince(Date.now)
		
		return timeRemaining
	}
    
    // CodingKeys
    enum CodingKeys: String, CodingKey {
        case _isRunning = "isRunning"
        case _hasStarted = "hasStarted"
        case _sessionDates = "sessionDates"
        case _pauses = "pauses"
		case _elapsedIntervals = "elapsedIntervals"
		case _hours = "hours"
		case _minutes = "minutes"
    }
}
