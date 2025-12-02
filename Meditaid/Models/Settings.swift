//
//  Settings.swift
//  Meditaid
//
//  Created by Krzysztof Garmulewicz on 01/12/2025.
//

import AppIntents
import Foundation

enum Mode: String, Codable {
    case zen, timer
}

extension Mode: AppEnum {
    static var typeDisplayName: LocalizedStringResource = "Mode"
    
    static var typeDisplayRepresentation:TypeDisplayRepresentation = "Mode"
    
    static var caseDisplayRepresentations: [Mode: DisplayRepresentation] = [
        .zen: "Zen",
        .timer: "Timer"
    ]
}

@Observable
class Settings: Codable {
    // General
    var mode: Mode = .zen {
        didSet { save() }
    }
    var healthKitEnabled: Bool = false {
        didSet { save() }
    }
    var healthKitToggleTapCounter: Int = 0 {
        didSet { save() }
    }
    
    // Interval Notifications
    var intervalsAreOn = false {
        didSet { save() }
    }
    var intervalOptions: [Duration] = [.seconds(5), .seconds(300), .seconds(600), .seconds(900), .seconds(1800), .seconds(2700), .seconds(3600)]
    var lastChosenDuration: Duration = .seconds(300) {
        didSet { save() }
    }
    var intervalDuration: Duration? {
        if intervalsAreOn {
            return lastChosenDuration
        } else {
            return nil
        }
    }
    var haptics: Bool = false {
        didSet { save() }
    }
    var sounds: Bool = false {
        didSet { save() }
    }

    // Timer
    var duration: Duration = .seconds(600) {
        didSet { save() }
    }
    
    var schemaVersion: Int? = 1
    
    func save() {
        LoadSave.save(self, to: "settings.json")
    }
    
    // Codable conformance
    enum CodingKeys: String, CodingKey {
        case _mode = "mode"
        case _healthKitEnabled = "healthKitEnabled"
        case _healthKitToggleTapCounter = "healthKitToggleTapCounter"
        case _intervalsAreOn = "intervalsAreOn"
        case _intervalOptions = "intervalOptions"
        case _lastChosenDuration = "lastChosenDuration"
        case _haptics = "haptics"
        case _sounds = "sounds"
        case _duration = "duration"
        case _schemaVersion = "schemaVersion"
    }
}
