//
//  ClipboardItem.swift
//  kopy
//
//  Created by Ahmet Öztemiz on 17.11.2025.
//

import Foundation

struct ClipboardItem: Identifiable, Equatable, Hashable {
    let id: UUID
    let timestamp: Date
    let content: String
    
    init(id: UUID = UUID(), timestamp: Date = Date(), content: String) {
        self.id = id
        self.timestamp = timestamp
        self.content = content
    }
    
    var preview: String {
        return content.count > 100 ? String(content.prefix(100)) + "..." : content
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: ClipboardItem, rhs: ClipboardItem) -> Bool {
        return lhs.id == rhs.id && lhs.content == rhs.content
    }
}

