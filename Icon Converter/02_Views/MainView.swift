//
//  MainView.swift
//  Icon Converter
//
//  Created by Janne Lehikoinen on 16.10.2025.
//

import SwiftUI

struct MainView: View {
    
    @Environment(DataStore.self) private var store
    @State private var displayingPopover = false
    @AppStorage(AppPreferences.exportSizeKey) var exportSize: Int = AppPreferences.defaultIconSize
    
    // MARK: Main view
    
    var body: some View {
        VStack(spacing: 30) {
            SizePickerView()
            DropView()
            Text(store.droppedImage.state.label)
            Button(action: {
                if let savePath = displaySavePanel() {
                    save(targetPath: savePath)
                }
            }) {
                Text("Save")
                    .frame(width: 150, height: 30, alignment: .center)
            }
            .disabled(store.droppedImage.state == .idle || store.droppedImage.state == .isDragging || store.droppedImage.state == .saved(""))
        }
        .fontDesign(.monospaced)
        .padding()
    }
    
    // MARK: View helper methods

    private func displaySavePanel() -> URL? {
        
        return store.displaySavePanel()
    }
    
    private func save(targetPath: URL) {
        
        store.save(targetPath: targetPath)
    }
}

#Preview {
    MainView()
}
