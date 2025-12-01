//
//  TimerAttributes.swift
//  Meditaid
//
//  Created by Krzysztof Garmulewicz on 01/12/2025.
//

import ActivityKit
import Foundation

struct TimerAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var startDate: Date
        var pauses: [TimeInterval]
        var isRunning: Bool
        
        var compoundedPauses: TimeInterval {
            var compPauses = TimeInterval.zero
            for pause in pauses {
                compPauses += pause
            }
            return compPauses
        }
        
        var totalTimeAdjusted: TimeInterval {
            Date().timeIntervalSince(startDate) - compoundedPauses
        }

        var startDateAdjusted: Date {
            return startDate.addingTimeInterval(compoundedPauses)
        }
    }
    // var mode: String or make Settings shared, then : Mode
    // var endDate = Date().addingTimeInterval(3600 * 24 * 365)
}
