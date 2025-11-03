//
//  AppConfig.swift
//  Icon Converter
//
//  Created by Janne Lehikoinen on 30.10.2025.
//

import Foundation

enum AppConfig {
    
    // GUI
    static let windowSize: CGFloat = 500
    
    // File extensions
    static let appBundleExtension = "app"
    static let pngExtension = "png"
    
    // Finder extension
    static let appBundleAttachmentType = "com.apple.application-bundle"
    
    // Build Settings > Versioning > Marketing Version = CFBundleShortVersionString in Info.plist
    static let appShortVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    static let buildNumber = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String
    
    static var appVersion: String {
        return "\(appShortVersion).\(buildNumber)"
    }
}
