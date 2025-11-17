//
//  kopyApp.swift
//  kopy
//
//  Created by Ahmet Öztemiz on 17.11.2025.
//

import SwiftUI

@main
struct kopyApp: App {
    var body: some Scene {
        WindowGroup {
            ClipboardHistoryView()
                .frame(minWidth: 450, minHeight: 600)
        }
        .windowResizability(.contentSize)
    }
}
