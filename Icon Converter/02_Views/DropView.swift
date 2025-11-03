//
//  DropView.swift
//  Icon Converter
//
//  Created by Janne Lehikoinen on 1.11.2025.
//

import SwiftUI

struct DropView: View {
    
    @Environment(DataStore.self) private var store
    @State private var isDragging = false
    
    var body: some View {
        store.droppedImage.state.symbol
            .resizable()
            .scaledToFit()
            .frame(width: 256, height: 256)
            .foregroundStyle(store.droppedImage.state.symbolColor)
            .opacity(store.droppedImage.state.symbolOpacity)
            .padding()
            .dropDestination(for: URL.self) { (urls, _) in
                Task {
                    store.iconIsAnimating.toggle()
                    guard let url = urls.first else { return }
                    store.droppedImage.appUrl = url
                    guard let appUrl = store.droppedImage.appUrl else { return }
                    await handleDrop(for: appUrl)
                }
                return true
            } isTargeted: {
                isDragging = $0
            }
            .onChange(of: isDragging) { _, newValue in
                
                store.iconIsAnimating.toggle()
                
                // newValue is true when the app bundle is on top of the drop zone
                // when app bundle is released onChange is called and newValue changes to false
                // => .idle placeholder symbol displays before app bundle animates
                store.droppedImage.state = newValue ? .isDragging : .idle
            }
            .animation(.easeOut(duration: 0.2), value: store.iconIsAnimating)
    }
    
    // MARK: View helper methods
    
    private func handleDrop(for url: URL) async {
        
        await store.handleDrop(for: url)
    }
}

#Preview {
    DropView()
}
