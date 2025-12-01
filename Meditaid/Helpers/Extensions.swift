//
//  Helpers.swift
//  Meditaid
//
//  Created by Krzysztof Garmulewicz on 01/12/2025.
//

import Foundation

extension TimeInterval {
    var formattedAdaptive: String {
        let minutes = Int(self) / 60
        let seconds = Int(self) % 60
        
        if self < 3600 {
            return String(format: "%d:%02d", minutes, seconds)
        } else {
            let hours = Int(self) / 3600
            let remainingMinutes = (Int(self) % 3600) / 60
            return String(format: "%d:%02d", hours, remainingMinutes)
        }
    }
}
