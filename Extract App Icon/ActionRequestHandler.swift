//
//  ActionRequestHandler.swift
//  Extract App Icon
//
//  Created by Janne Lehikoinen on 27.10.2025.
//

import Foundation
import AppKit
import os

class ActionRequestHandler: NSObject, NSExtensionRequestHandling {

    func beginRequest(with context: NSExtensionContext) {
        
        // Get the input item
        let inputItem = context.inputItems[0] as! NSExtensionItem
        
        guard let inputAttachments = inputItem.attachments else {
            preconditionFailure("Expected a valid array of attachments")
        }

        for attachment in inputAttachments {
            attachment.loadInPlaceFileRepresentation(forTypeIdentifier: "public.directory") { [unowned self] (appUrl, inPlace, error) in
                if let appUrl {
                    let urlSchemeTargetUrl = appUrl.path
                    Logger.quickActionExtension.info("Finder Quick Action URL: \(urlSchemeTargetUrl)")
                    
                    /// Custom URL Scheme is configured in Info > URL Types
                    NSWorkspace.shared.open(URL(string: "iconconverter:\(urlSchemeTargetUrl)")!)
                }
            }
        }
    }
}
