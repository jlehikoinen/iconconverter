//
//  DataStore.swift
//  Icon Converter
//
//  Created by Janne Lehikoinen on 24.10.2025.
//

import SwiftUI
import UniformTypeIdentifiers
import os

@MainActor
@Observable
class DataStore {
    
    //
    let iconFactory = IconFactory()
    
    //
    var droppedImage: IconImage = IconImage()
    var iconIsAnimating = false
    
    // MARK: Methods
    
    func handleDrop(for url: URL) async {
        
        let image = await iconFactory.handleDrop(for: url)
        droppedImage.image = image
        droppedImage.state = .droppedSuccess(image)
    }
    
    /// Signing & Capabilities > App Sandbox > File Access > User Selected File
    /// Permission Access: Read/Write
    func displaySavePanel() -> URL? {
        
        let panel = NSSavePanel()
        panel.allowedContentTypes = [.png]
        panel.canCreateDirectories = true
        if let appUrl = droppedImage.appUrl {
            panel.nameFieldStringValue = appUrl.appName
        }
        panel.isExtensionHidden = false
        panel.title = "Save icon"
        
        let response = panel.runModal()
        return response == .OK ? panel.url : nil
    }
    
    func save(targetPath: URL) {
        
        droppedImage.saveUrl = targetPath
        droppedImage.state = .saved(targetPath.path)
        
        do {
            try iconFactory.save(droppedImage)
        } catch {
            Logger.app.error("\(AppError.saveFailed(error))")
        }
    }
}
