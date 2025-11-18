//
//  Convert.swift
//  iconconverter
//
//  Created by Janne Lehikoinen on 30.10.2025.
//

import Foundation
import ArgumentParser

extension Iconconverter {
    
    struct Convert: AsyncParsableCommand {
        
        static var configuration = CommandConfiguration(
            abstract: "Convert app bundle icon to png file.",
            usage: """
                iconconverter convert path/to/Example.app path/to/savelocation [--size 256]
                """
        )
        
        @Argument(help: "Path to the app bundle.")
        var appPath: String
        
        @Argument(help: "Path to the save location.")
        var savePath: String
        
        @Option(help: "Configure icon export size. Size options: 32, 64, 128, 256, 512 & 1024. Default value: 512.")
        var size: Int?
        
        func run() async throws {
            
            //
            let appValidator = CLIInputValidator(path: appPath)
            let saveLocationValidator = CLIInputValidator(path: savePath)
            guard appValidator.isValidAppBundle() else { return }
            guard saveLocationValidator.isValidSaveLocation() else { return }
            
            //
            let iconFactory = IconFactory()
            var iconImage = IconImage(appUrl: URL(fileURLWithPath: appPath), saveUrl: URL(fileURLWithPath: savePath))
            
            if let size {
                iconImage.size = size / 2
                guard CLIInputValidator.isValidSize(iconImage) else { return }
            }
            
            await iconFactory.process(iconImage)
        }
    }
}
