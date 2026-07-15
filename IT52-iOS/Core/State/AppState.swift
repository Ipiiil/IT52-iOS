//
//  AppState.swift
//  IT52-iOS
//
//  Created by Полина Терехина on 14.07.2026.
//
// теперь только под интересы
 import Foundation
import Observation

@Observable

final class AppState{
    
    var selectedInterests: [String] = []
    
    var selectedInterestsIDs: [Int] = []
}
