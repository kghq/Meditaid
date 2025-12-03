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
    
    // CodingKeys
    enum CodingKeys: String, CodingKey {
        case _isRunning = "isRunning"
        case _hasStarted = "hasStarted"
        case _sessionDates = "sessionDates"
        case _pauses = "pauses"
    }
}
