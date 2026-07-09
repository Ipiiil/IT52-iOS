//
//  IT52_iOSApp.swift
//  IT52-iOS
//
//  Created by Полина Терехина on 06.07.2026.
//

import SwiftUI

@main
struct IT52_iOSApp: App {
    
    @State private var eventsViewModel = EventsViewModel()
    @State private var attendanceStore = AttendanceStore()
    @State private var appState = AppState()
    
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(eventsViewModel)
                .environment(attendanceStore)
                .environment(appState)
        }
    }
}
