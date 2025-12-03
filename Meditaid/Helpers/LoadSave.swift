//
//  LoadSave.swift
//  Meditaid
//
//  Created by Krzysztof Garmulewicz on 01/12/2025.
//

import Foundation

struct LoadSave {
    static func save<T: Codable>(_ items: T, to fileDirectory: String) {
        if let data = try? JSONEncoder().encode(items) {
            let url = URL.documentsDirectory.appending(path: fileDirectory)
            do {
                try data.write(to: url, options: [.atomic, .completeFileProtection])
            } catch {
            }
        }
    }
    
    static func load<T: Codable>(from fileDirectory: String) throws -> T {
        let url = URL.documentsDirectory.appending(path: fileDirectory)
        let data = try Data(contentsOf: url)
        return try JSONDecoder().decode(T.self, from: data)
    }
    
    // TODO: - Schema Migration
}
