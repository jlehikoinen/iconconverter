//
//  CLIInputValidator.swift
//  iconconverter
//
//  Created by Janne Lehikoinen on 30.10.2025.
//

import Foundation

struct CLIInputValidator {
    
    let fileManager = FileManager.default
    let path: String
    
    //
    
    var filePathURL: URL {
        URL(fileURLWithPath: path)
    }
    
    //
    
    func isValidAppBundle() -> Bool {
        
        guard isValidFolder() else { return false }
        guard filePathURL.isAppBundle else {
            print(CLIInputError.notAnAppBundle(path).description)
            return false
        }
        return true
    }
    
    func isValidSaveLocation() -> Bool {
        
        return isValidFolder()
    }
    
    private func isValidFolder() -> Bool {
        
        guard fileManager.fileExists(atPath: path) else {
            print(CLIInputError.nonExistentPath(path).description)
            return false
        }
        
        guard filePathURL.isDirectory else {
            print(CLIInputError.notADirectory(path).description)
            return false
        }
        
        return true
    }
}
