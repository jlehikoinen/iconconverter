//
//  AppError.swift
//  Icon Converter
//
//  Created by Janne Lehikoinen on 2.11.2025.
//

import Foundation

enum AppError: Error {
    
    case saveFailed(Error)
    
    var description: String {
        switch self {
        case .saveFailed(let error):
            return "ERROR: Failed to save icon: \(error)"
        }
    }
}
