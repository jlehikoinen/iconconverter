//
//  SizePickerView.swift
//  Icon Converter
//
//  Created by Janne Lehikoinen on 29.10.2025.
//

import SwiftUI

struct SizePickerView: View {
    
    @Environment(DataStore.self) private var store
    @AppStorage(AppPreferences.targetSizeKey,
                store: UserDefaults(suiteName: AppPreferences.suiteName)) var targetSize: Int = AppPreferences.defaultIconSize
    
    var sizes = IconSize.allCases
    
    var body: some View {
        HStack {
            Text("Export size:")
            Picker("Export size", selection: $targetSize) {
                Spacer()
                ForEach(sizes, id: \.rawValue) { size in
                    Text("\(size.doubled) x \(size.doubled)")
                }
            }
            .labelsHidden()
            .onChange(of: targetSize) { _, _ in
                
                store.iconIsAnimating.toggle()
                
                Task {
                    if let appUrl = store.droppedImage.appUrl {
                        await store.handleDrop(for: appUrl)
                    }
                }
            }
        }
    }
}
