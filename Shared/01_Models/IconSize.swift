//
//  IconSize.swift
//  Icon Converter
//
//  Created by Janne Lehikoinen on 27.10.2025.
//

/// Using NSWorkspace.shared.icon(forFile:).bestRepresentation with
/// width: 256 x height: 256 sizes results in 512 x 512 sized icon
/// e.g. When user selects 512 x 512 size the app translates it to 256 x 256
enum IconSize: Int, CaseIterable {
    
    case XXS = 16
    case XS = 32
    case S = 64
    case M = 128
    case L = 256
    case XL = 512
    
    var doubled: Int {
        rawValue * 2
    }
}
