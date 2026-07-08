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
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(eventsViewModel)
        }
    }
}
