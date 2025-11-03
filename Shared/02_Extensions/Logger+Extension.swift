//
//  Logger+Extension.swift
//  Icon Converter
//
//  Created by Janne Lehikoinen on 28.10.2025.
//

import Foundation
import os

extension Logger {
    
    private static var subsystem = Bundle.main.bundleIdentifier!
    static let app = Logger(subsystem: subsystem, category: "app")
    static let cli = Logger(subsystem: subsystem, category: "cli")
    static let quickActionExtension = Logger(subsystem: subsystem, category: "quickActionExtension")
}
