//
//  HealthKitManager.swift
//  Meditaid
//
//  Created by Krzysztof Garmulewicz on 01/12/2025.
//

import Foundation
import HealthKit

class HealthKitManager {
    private let healthStore = HKHealthStore()
    
    private let mindfulType = HKCategoryType.categoryType(forIdentifier: .mindfulSession)!

    // Request authorization from the user
    func requestAuthorization(completion: @escaping (Bool, Error?) -> Void) {
        let typesToShare: Set = [mindfulType]
        
        healthStore.requestAuthorization(toShare: typesToShare, read: nil, completion: completion)
    }
    
    func checkAuthorization() -> Bool {
        switch healthStore.authorizationStatus(for: mindfulType) {
        case .sharingAuthorized: return true
        case .sharingDenied: return false
        default: return false
        }
    }

    // Save a mindful session
    func saveMindfulSession(minutes: Int, startDate: Date, endDate: Date) {
        let mindfulSample = HKCategorySample(
            type: mindfulType,
            value: 0,
            start: startDate,
            end: endDate
        )

        healthStore.save(mindfulSample) { success, error in
            if let error = error {
                print("Error saving mindful minutes: \(error.localizedDescription)")
            } else if success {
                print("Successfully saved \(minutes) mindful minutes to Health app")
            }
        }
    }
}
