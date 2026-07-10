//
//  UserProfile.swift
//  IT52-iOS
//
//  Created by Полина Терехина on 10.07.2026.
//

import Foundation

struct UserProfile {
    
    var avatarURL: String?
    
    var nickname: String = ""
    
    var firstName: String = ""
    
    var lastName: String = ""
    
    var email: String = ""
    
    var employmet: String = ""
    
    var website: String = ""
    
    var bio: String = ""
    
    var isPrivate: Bool = false
    
    var notificationsEnabled: Bool = true
    
    var interests: [String] = []
}
