//
//  ClipboardManager.swift
//  kopy
//
//  Created by Ahmet Öztemiz on 17.11.2025.
//

import Foundation
import AppKit
import Combine

@MainActor
class ClipboardManager: ObservableObject {
    static let shared = ClipboardManager()
    
    @Published var items: [ClipboardItem] = []
    
    private var pasteboard: NSPasteboard
    private var changeCount: Int
    private var timer: Timer?
    private let maxItems = 100
    
    private init() {
        self.pasteboard = NSPasteboard.general
        self.changeCount = pasteboard.changeCount
        startMonitoring()
    }
    
    func startMonitoring() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] _ in
            Task { @MainActor in
                self?.checkClipboard()
            }
        }
    }
    
    func stopMonitoring() {
        timer?.invalidate()
        timer = nil
    }
    
    private func checkClipboard() {
        let newChangeCount = pasteboard.changeCount
        
        guard newChangeCount != changeCount else { return }
        
        changeCount = newChangeCount
        
        if let string = pasteboard.string(forType: .string), !string.isEmpty {
            // Don't duplicate if it's the same as the last item
            if let lastItem = items.first, lastItem.content == string {
                return
            }
            
            let item = ClipboardItem(content: string)
            addItem(item)
        }
    }
    
    private func addItem(_ item: ClipboardItem) {
        // Remove duplicates
        items.removeAll { $0.content == item.content }
        
        // Add to beginning
        items.insert(item, at: 0)
        
        // Limit to maxItems
        if items.count > maxItems {
            items = Array(items.prefix(maxItems))
        }
    }
    
    func copyItem(_ item: ClipboardItem) {
        pasteboard.clearContents()
        pasteboard.setString(item.content, forType: .string)
        changeCount = pasteboard.changeCount
    }
    
    func clearAll() {
        items.removeAll()
    }
}

