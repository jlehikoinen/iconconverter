//
//  IconConverterApp.swift
//  Icon Converter
//
//  Created by Janne Lehikoinen on 23.10.2025.
//

import SwiftUI
import os

@main
struct IconConverterApp: App {
    
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State private var store = DataStore()
    
    var body: some Scene {
        Window("Icon Converter", id: "main") {
            MainView()
                .frame(minWidth: AppConfig.windowSize, idealWidth: AppConfig.windowSize, minHeight: AppConfig.windowSize, idealHeight: AppConfig.windowSize)
                .environment(store)
                /// "Drop app icon to Dock icon" support is configured in Info > Document Types
                .onOpenURL { url in
                    Task {
                        
                        // TEMP
                        Logger.app.info("\(AppConfig.appVersion)")
                        
                        store.iconIsAnimating.toggle()
                        Logger.app.info("The app was launched when an app icon was dropped onto the Dock icon or from the Finder Quick Action with an URL: \(url.path)")
                        store.droppedImage.appUrl = url
                        if let appUrl = store.droppedImage.appUrl {
                            await store.handleDrop(for: appUrl)
                        }
                    }
                }
        }
    }
}

// Use AppDelegate to access AppKit APIs
class AppDelegate: NSObject, NSApplicationDelegate {
    
    // Close the app when the red button is clicked
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        true
    }
}
