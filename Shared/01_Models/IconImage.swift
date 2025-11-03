//
//  IconImage.swift
//  Icon Converter
//
//  Created by Janne Lehikoinen on 30.10.2025.
//

import Foundation
import AppKit

struct IconImage {
    
    var image = NSImage()
    var appUrl: URL?
    var saveUrl: URL?
    var size: Int = AppPreferences.defaultIconSize
    var state: FileDropState = .idle
    
    var humanFriendlySize: Int {
        size * 2
    }
}
