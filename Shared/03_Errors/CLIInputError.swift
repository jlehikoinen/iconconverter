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
    case invalidSize(Int)
    
    var description: String {
        switch self {
        case .nonExistentPath(let path):
            return "ERROR: path doesn't exist: \(path)"
        case .notAnAppBundle(let path):
            return "ERROR: path is not an app bundle: \(path)"
        case .notADirectory(let path):
            return "ERROR: path is not a directory: \(path)"
        case .invalidSize(let size):
            return "ERROR: invalid size: \(size). Min. value is 32, max. value is 1024."
        }
    }
}
