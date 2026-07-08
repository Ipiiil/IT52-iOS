//
//  Event.swift
//  IT52-iOS
//
//  Created by Полина Терехина on 06.07.2026.
//

import Foundation

struct Event: Identifiable {
    
    let id: Int
    
    let title: String
    
    let description: String
    
    let date: Date
    
    let location: String
    
    let organized: String
    
    let category: String
    
    let imageURL: String?
    
    let isFavorite: Bool
    
    let isRegistered: Bool
}

