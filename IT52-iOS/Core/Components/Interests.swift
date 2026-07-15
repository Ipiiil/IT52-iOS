//
//  Interests.swift
//  IT52-iOS
//
//  Created by Полина Терехина on 10.07.2026.
//

import Foundation

enum Interests {
    
    static let all = [
        
        "Backend",
        "BigData",
        "Cloud",
        "Data Science",
        "Defcon",
        "DevOps",
        "DevRel",
        "FrontEnd",
        "SecOps",
        "Security",
        "Softskills",
        "SRE",
        "SW Testing",
        "Test Automation",
        "Бизнес Анализ",
        "Дизайн UI|UX",
        "HR",
        "IoT",
        "ML|AI",
        "Mobile",
        "Pentest",
        "Product Management",
        "QA",
        "SDET",
        "Карьера",
        "Маркетинг",
        "Менеджмент",
        "Разработка",
        "Системный Анализ"
    ]
    
    
    static func id(for name: String) -> Int? {
        switch name {
            
        case "Backend":
            return 22
            
        case "BigData":
            return 12
            
        case "Cloud":
            return 10
            
        case "Data Science":
            return 11
            
        case "Defcon":
            return 29
            
        case "DevOps":
            return 8
            
        case "DevRel":
            return 7
            
        case "FrontEnd":
            return 23
            
        case "SecOps":
            return 14
            
        case "Security":
            return 13
            
        case "Softskills":
            return 5
            
        case "SRE":
            return 9
            
        case "SW Testing":
            return 17
            
        case "Test Automation":
            return 18
            
        case "Бизнес Анализ":
            return 26
            
        case "Дизайн UI|UX":
            return 3
            
        case "HR":
            return 6
            
        case "IoT":
            return 21
            
        case "ML|AI":
            return 20
            
        case "Mobile":
            return 24
            
        case "Pentest":
            return 28
            
        case "Product Management":
            return 15
            
        case "QA":
            return 16
            
        case "SDET":
            return 19
            
        case "Карьера":
            return 27
            
        case "Маркетинг":
            return 1
            
        case "Менеджмент":
            return 2
            
        case "Разработка":
            return 4
            
        case "Системный Анализ":
            return 25
            
        default:
            return nil
        }
    }
    
    static func names(for ids: [Int]) -> [String] {
        all.filter { interest in
            if let id = id(for: interest) {
                return ids.contains(id)
            }
            return false
        }
    }
    
    static func idForEventTag(_ tag: String) -> Int? {

        let normalized = TagNormalizer.normalize(tag)

        if let aliasID = eventAliases[normalized] {
            return aliasID
        }

        return all.first { interest in
            TagNormalizer.normalize(interest) == normalized
        }.flatMap {
            id(for: $0)
        }
    }
    
    static let eventAliases: [String: Int] = [

        "backend": 22,
        "frontend": 23,
        "front end": 23,

        "devops": 8,

        "ui": 3,
        "ux": 3,

        "web design": 3,
        "веб дизайн": 3,

        "development": 4,
        "разработка": 4,
        "programming": 4,

        "qa": 16,
        "testing": 17,
        "autotest": 18,

        "system analysis": 25,
        "analysis": 25
    ]
}
