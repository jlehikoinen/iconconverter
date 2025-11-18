//
//  CLIInputError.swift
//  Icon Converter
//
//  Created by Janne Lehikoinen on 30.10.2025.
//

enum CLIInputError: Error {
    
    case nonExistentPath(String)
    case notAnAppBundle(String)
    case notADirectory(String)
    case invalidSize
    
    var description: String {
        switch self {
        case .nonExistentPath(let path):
            return "ERROR: path doesn't exist: \(path)"
        case .notAnAppBundle(let path):
            return "ERROR: path is not an app bundle: \(path)"
        case .notADirectory(let path):
            return "ERROR: path is not a directory: \(path)"
        case .invalidSize:
            return "ERROR: invalid size. Min. value is \(IconSize.min), max. value is \(IconSize.max)."
        }
    }
}
