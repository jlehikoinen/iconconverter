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
    static let targetSizeKey = "targetSize"
    
    /// Default values
    static let defaultSavePathIsConfigured = false
    static let defaultSavePath = "/Users/Shared"
    static let defaultIconSize = IconSize.L.rawValue        // See IconSize enum
    
    /// Handle default values
    static let targetSize = sharedDefaults?.integer(forKey: AppPreferences.targetSizeKey) ?? AppPreferences.defaultIconSize
}
