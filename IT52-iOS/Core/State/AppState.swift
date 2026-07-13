//
//  AppState.swift
//  IT52-iOS
//
//  Created by Полина Терехина on 07.07.2026.
//

import Foundation
import Observation

@Observable
final class AppState {
    
    var isAuthenticated = false
    
    var selectedInterests: [String] = []
    
}
