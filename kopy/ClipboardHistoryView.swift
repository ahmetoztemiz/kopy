//
//  ClipboardHistoryView.swift
//  kopy
//
//  Created by Ahmet Öztemiz on 17.11.2025.
//

import SwiftUI

struct ClipboardHistoryView: View {
    @StateObject private var clipboardManager = ClipboardManager.shared
    @State private var searchText: String = ""
    @FocusState private var isSearchFocused: Bool
    
    private var filteredItems: [ClipboardItem] {
        if searchText.isEmpty {
            return clipboardManager.items
        }
        let searchLowercased = searchText.lowercased()
        return clipboardManager.items.filter { $0.content.lowercased().contains(searchLowercased) }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Header with Clear All button
            HStack {
                Text("Clipboard History")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Spacer()
                
                if !clipboardManager.items.isEmpty {
                    Button(action: {
                        clipboardManager.clearAll()
                    }) {
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                    }
                    .buttonStyle(.plain)
                    .help("Clear All")
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color(NSColor.controlBackgroundColor))
            
            Divider()
            
            // Search bar
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)
                
                TextField("Search...", text: $searchText)
                    .textFieldStyle(.plain)
                    .focused($isSearchFocused)
                
                if !searchText.isEmpty {
                    Button(action: {
                        searchText = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.secondary)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(10)
            .background(Color(NSColor.textBackgroundColor))
            .cornerRadius(8)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            
            Divider()
            
            // Items list
            if filteredItems.isEmpty {
                VStack(spacing: 12) {
                    Spacer()
                    Image(systemName: clipboardManager.items.isEmpty ? "clipboard" : "magnifyingglass")
                        .font(.system(size: 48))
                        .foregroundColor(.secondary)
                    Text(clipboardManager.items.isEmpty ? "No clipboard items" : "No items found")
                        .foregroundColor(.secondary)
                        .font(.subheadline)
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollView {
                    VStack(spacing: 0) {
                        SwiftUI.ForEach(filteredItems) { (item: ClipboardItem) in
                            ClipboardItemRow(item: item)
                                .onTapGesture {
                                    clipboardManager.copyItem(item)
                                    // Provide haptic feedback
                                    NSHapticFeedbackManager.defaultPerformer.perform(.alignment, performanceTime: .default)
                                }
                        }
                    }
                }
            }
        }
        .frame(width: 450, height: 600)
        .onAppear {
            // Auto-focus search bar when view appears
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isSearchFocused = true
            }
        }
    }
}

struct ClipboardItemRow: View {
    let item: ClipboardItem
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(item.content)
                .font(.system(size: 13))
                .lineLimit(3)
                .multilineTextAlignment(.leading)
                .foregroundColor(.primary)
            
            Text(item.timestamp, style: .relative)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(NSColor.textBackgroundColor))
        .contentShape(Rectangle())
        .onHover { isHovered in
            // Visual feedback could be added here
        }
        
        Divider()
    }
}

#Preview {
    ClipboardHistoryView()
}

