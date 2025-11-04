//
//  AppPreferences.swift
//  Icon Converter
//
//  Created by Janne Lehikoinen on 27.10.2025.
//

import Foundation

enum AppPreferences {
    
    /// App Groups
    static let suiteName = "group.com.github.IconConverter"
    static let sharedDefaults = UserDefaults.init(suiteName: AppPreferences.suiteName)
    
    /// Keys
    static let exportSizeKey = "exportSize"
    
    /// Default values
    static let defaultIconSize = IconSize.L.rawValue        // See IconSize enum
    
    /// Handle default values
    static let exportSize = sharedDefaults?.integer(forKey: AppPreferences.exportSizeKey) ?? AppPreferences.defaultIconSize
}
