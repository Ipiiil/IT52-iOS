//
//  TagNormalizer.swift
//  IT52-iOS
//
//  Created by Полина Терехина on 13.07.2026.
//

import Foundation

struct TagNormalizer {
    
    static func normalize(_ tag: String) -> String {
        tag
            .lowercased()
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    static func normalizeList(_ tags: [String]) -> [String] {
        tags.map{
            normalize($0)
        }
    }
}
