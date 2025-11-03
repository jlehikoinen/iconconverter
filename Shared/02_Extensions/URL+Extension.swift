//
//  URL+Extension.swift
//  Icon Converter
//
//  Created by Janne Lehikoinen on 28.10.2025.
//

import Foundation

extension URL {
    
    var appName: String {
        self.deletingPathExtension().lastPathComponent
    }
    
    var iconFileName: String {
        return self.deletingPathExtension().appendingPathExtension(AppConfig.pngExtension).lastPathComponent
    }
    
    var iconFileNameWithTimestamp: String {
        let timestamp = Date().timeIntervalSince1970
        let fileNameWithOutExtension = self.deletingPathExtension().lastPathComponent
        return "\(fileNameWithOutExtension)-\(timestamp).\((AppConfig.pngExtension))"
    }
    
    var isDirectory: Bool {
       (try? resourceValues(forKeys: [.isDirectoryKey]))?.isDirectory == true
    }
    
    var isAppBundle: Bool {
        return self.pathExtension == AppConfig.appBundleExtension
    }
}
