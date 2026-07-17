//
//  EventTextCleaner.swift
//  IT52-iOS
//
//  Created by Полина Терехина on 17.07.2026.
//

import Foundation

enum EventTextCleaner {

    static func clean(_ text: String) -> String {
        removeEmoji(text)
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }


    static func shortDescription(_ text: String, maxCharacters: Int = 120) -> String {

        let cleaned = clean(text)

        var result = ""
        var first = true

        for word in cleaned.split(whereSeparator: \.isWhitespace) {

            let candidate = first
                ? String(word)
                : result + " " + word

            if candidate.count > maxCharacters {
                return result.isEmpty ? String(word) : result + "..."
            }

            result = candidate
            first = false
        }

        return result
    }


    private static func removeEmoji(_ text: String) -> String {

        text.filter { character in
            !character.unicodeScalars.contains { scalar in

                scalar.properties.isEmoji
            }
        }
    }
}
