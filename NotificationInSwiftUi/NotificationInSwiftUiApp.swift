//
//  NotificationInSwiftUiApp.swift
//  NotificationInSwiftUi
//
//  Created by Muhammad Zeeshan on 25/10/2024.
//

import SwiftUI

@main
struct NotificationInSwiftUiApp: App {
    @StateObject var localNManager = NotificationManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(localNManager)
        }
    }
}
