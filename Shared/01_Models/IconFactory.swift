//
//  IconFactory.swift
//  Icon Converter
//
//  Created by Janne Lehikoinen on 28.10.2025.
//

import AppKit
import SwiftUI
import os

struct IconFactory {
    
    @AppStorage(AppPreferences.exportSizeKey) var exportSize: Int = AppPreferences.defaultIconSize
    
    func handleDrop(for url: URL) async -> NSImage {
        
        var image = NSImage()
        
        // width: 256, height: 256 results in 512 x 512 sized icon
        if let representation = NSWorkspace.shared.icon(forFile: url.path)
            .bestRepresentation(for: NSRect(x: 0,
                                            y: 0,
                                            width: exportSize,
                                            height: exportSize),
                                context: nil,
                                hints: nil) {
            image = NSImage(size: representation.size)
            image.addRepresentation(representation)
        }
        return image
    }
    
    func save(_ iconImage: IconImage) throws {
        
        guard let saveUrl = iconImage.saveUrl else { return }
        
        if let tiffData = iconImage.image.tiffRepresentation, let bitmapRep = NSBitmapImageRep(data: tiffData) {
            let pngData = bitmapRep.representation(using: .png, properties: [:])
            do {
                try pngData!.write(to: saveUrl)
            } catch {
                Logger.app.error("\(AppError.saveFailed(error))")
                return
            }
        }
    }
    
    /// Method for CLI
    func process(_ iconImage: IconImage) async {
        
        var processedIconImage = iconImage
        
        if let representation = NSWorkspace.shared.icon(forFile: iconImage.appUrl!.path)
            .bestRepresentation(for: NSRect(x: 0,
                                            y: 0,
                                            width: iconImage.size,
                                            height: iconImage.size),
                                context: nil,
                                hints: nil) {
            processedIconImage.image = NSImage(size: representation.size)
            processedIconImage.image.addRepresentation(representation)
        }
        
        // Path validation handled before these force unwraps
        var fileName = iconImage.appUrl!.iconFileName
        processedIconImage.saveUrl = iconImage.saveUrl!.appendingPathComponent(fileName)
        
        if FileManager.default.fileExists(atPath: processedIconImage.saveUrl!.path) {
            fileName = iconImage.appUrl!.iconFileNameWithTimestamp
            processedIconImage.saveUrl = iconImage.saveUrl!.appendingPathComponent(fileName)
        }
        
        do {
            try save(processedIconImage)
        } catch {
            Logger.app.error("\(AppError.saveFailed(error))")
        }
    }
}
