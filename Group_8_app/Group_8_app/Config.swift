//
//  Config.swift
//  Group_8_app
//
//  Created by Kyrollos Ceriacous on 2023-05-24.
//

import Foundation

struct Config {
    private static var configDictionary: [String: String] {
        if let path = Bundle.main.path(forResource: "Config", ofType: "plist"),
            let dict = NSDictionary(contentsOfFile: path) as? [String: String] {
            return dict
        }
        return [:]
    }

    static var securityKey: String? {
        return configDictionary["securityKey"]
    }
}
