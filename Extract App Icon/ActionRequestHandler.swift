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
            
            // Allow only app bundle attachment types
            guard let attachmentTypeID = attachment.registeredTypeIdentifiers.first else { continue }
            Logger.quickActionExtension.info("Attachment type: \(attachmentTypeID)")
            if attachmentTypeID != AppConfig.appBundleAttachmentType {
                // cancelRequest crashes the extension that's why "success" = completeRequest is used here
                context.completeRequest(returningItems: [inputItem], completionHandler: nil)
//                context.cancelRequest(withError: NSError(domain: NSCocoaErrorDomain, code: NSUserCancelledError, userInfo: nil))
                return
            }
            
            attachment.loadInPlaceFileRepresentation(forTypeIdentifier: AppConfig.appBundleAttachmentType) { (appUrl, inPlace, error) in
                if let appUrl {
                    let urlSchemeTargetUrl = appUrl.path
                    Logger.quickActionExtension.info("Finder Quick Action URL: \(urlSchemeTargetUrl)")
                    
                    /// Custom URL Scheme is configured in Info > URL Types
                    NSWorkspace.shared.open(URL(string: "iconconverter:\(urlSchemeTargetUrl)")!)
                    
                    // Notify the action is done with success
                    context.completeRequest(returningItems: [inputItem], completionHandler: nil)
                }
            }
        }
    }
}
