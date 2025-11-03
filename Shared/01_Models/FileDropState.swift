//
//  FileDropState.swift
//  Icon Converter
//
//  Created by Janne Lehikoinen on 17.10.2025.
//

import SwiftUI

// MARK: Helper enum for file drop state changes

enum FileDropState: Equatable {
    
    case idle
    case isDragging
    case isProcessing
    case droppedSuccess(NSImage)
    case droppedError(String)
    case saved(String)
    
    var label: String {
        switch self {
        case .idle: "Drop an app bundle here"
        case .isDragging: "Almost there..."
        case .isProcessing: "Processing..."
        case .droppedSuccess: "Here's your icon"
        case .droppedError(let errorOutput): "\(errorOutput)"
        case .saved(let path): "Icon saved successfully to \(path)"
        }
    }
    
    var symbol: Image {
        switch self {
        case .idle: Image(systemName: "plus.viewfinder")
        case .isDragging: Image(systemName: "plus.viewfinder")
        case .isProcessing: Image(systemName: "tortoise")
        case .droppedSuccess(let image): Image(nsImage: image)
        case .droppedError: Image(systemName: "exclamationmark.square")
        case .saved: Image(systemName: "plus.viewfinder")
        }
    }
    
    var symbolColor: Color {
        switch self {
        case .idle: .gray
        case .isDragging: .gray
        case .isProcessing: .blue
        case .droppedSuccess: .green
        case .droppedError: .red
        case .saved: .gray
        }
    }
    
    var symbolOpacity: Double {
        switch self {
        case .idle: 0.5
        case .isDragging: 1.0
        case .isProcessing: 1.0
        case .droppedSuccess: 1.0
        case .droppedError: 1.0
        case .saved: 0.5
        }
    }
}
