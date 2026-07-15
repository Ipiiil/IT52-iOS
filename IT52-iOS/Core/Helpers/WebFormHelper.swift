//
//  WebFormHelper.swift
//  IT52-iOS
//
//  Created by Полина Терехина on 14.07.2026.
//

import Foundation

enum WebFormHelper {
    
    //достаем токен из страницы
    static func fetchCSRFToken(from url: URL) async throws -> String {
        let(data, _) = try await URLSession.shared.data(from: url)
        return try extractCSRFToken(from: data)
    }
    
    static func extractCSRFToken(from html: Data) throws -> String{
        guard let htmlString = String(data: html, encoding: .utf8) else {
            throw AuthError.csrfTokenNotFound
        }
        
        let pattern = #"<meta name="csrf-token" content="([^"]+)""#
        guard let regex = try? NSRegularExpression(pattern: pattern),
              let match = regex.firstMatch(in: htmlString, range: NSRange(htmlString.startIndex..., in: htmlString)),
              let range = Range(match.range(at: 1), in: htmlString) else {
            throw AuthError.csrfTokenNotFound
        }
        return String(htmlString[range])
    }
    
    static func formEncode(_ params: [String: String]) -> Data {
        var allowedCharacters = CharacterSet.alphanumerics
        allowedCharacters.insert(charactersIn: "-._~")
        
        return params
            .map {key, value in
                let encodedKey = key.addingPercentEncoding(withAllowedCharacters: allowedCharacters) ?? key
                let encodedValue = value.addingPercentEncoding(withAllowedCharacters: allowedCharacters) ?? value
                return "\(encodedKey)=\(encodedValue)"
            }
            .joined(separator: "&")
            .data(using: .utf8) ?? Data()
    }
    
    static func multipartBody(
        fields: [(String, String)],
        fileField: String?,
        fileData: Data?,
        fileName: String,
        mimeType: String,
        boundary: String
    ) -> Data{
        var body = Data()
        
        func appendString(_ string: String) {
            body.append(string.data(using: .utf8)!)
        }
        
        for (key, value) in fields {
            appendString("--\(boundary)\r\n")
            appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            appendString("\(value)\r\n")
        }
        
        if let fileField, let fileData {
            appendString("--\(boundary)\r\n")
            appendString("Content-Disposition: form-data; name=\"\(fileField)\"; filename=\"\(fileName)\"\r\n")
            appendString("Content-Type: \(mimeType)\r\n\r\n")
            body.append(fileData)
            appendString("\r\n")
        }
        
        appendString("--\(boundary)--\r\n")
        return body
    }
    
    static func extractInputValue(name: String, from html: String, preferring type: String? = nil) -> String?{
        let escapedName = NSRegularExpression.escapedPattern(for: name)
        let pattern = #"<input[^>]*name="\#(escapedName)"[^>]*>"#
        guard let regex = try? NSRegularExpression(pattern: pattern) else {
            return nil
        }
        
        let matches = regex.matches(in: html, range: NSRange(html.startIndex..., in: html))
        let tags: [String] = matches.compactMap{
            guard let range = Range($0.range, in: html) else {return nil}
            return String(html[range])
        }
        
        let candidateTags = type != nil ? tags.filter {$0.contains("type=\"\(type!)\"") } : tags.filter { !$0.contains("type=\"hidden\"")}
        let tag = candidateTags.first ?? tags.first
        
        guard let tag,
              let valueRange = tag.range(of: #"value="([^"]*)""#, options: .regularExpression) else {
            return nil
        }
        let valueMatch = String(tag[valueRange])
        return valueMatch
            .replacingOccurrences(of: "value=\"", with: "")
            .replacingOccurrences(of: "\"", with: "")
    }
    
    static func extractCheckboxChecked(name: String, from html: String) -> Bool {
        let escapedName = NSRegularExpression.escapedPattern(for: name)
        let pattern = #"<input[^>]*type="checkbox"[^>]*name="\#(escapedName)"[^>]*>"#
        guard let regex = try? NSRegularExpression(pattern: pattern),
              let match = regex.firstMatch(in: html, range: NSRange(html.startIndex..., in: html)),
              let range = Range(match.range, in: html) else {
            return false
        }
        return html[range].contains("checked")
        
    }
    
    static func extractTextareaValue(name: String, from html: String) -> String?{
        let escapedName = NSRegularExpression.escapedPattern(for: name)
        let pattern = #"<textarea[^>]*name="\#(escapedName)"[^>]*>([\s\S]*?)</textarea>"#
        guard let regex = try? NSRegularExpression(pattern: pattern),
              let match = regex.firstMatch(in: html, range: NSRange(html.startIndex..., in: html)),
              let range = Range(match.range(at: 1), in: html) else {
            return nil
        }
        return String(html[range]).trimmingCharacters(in: .whitespacesAndNewlines)
        
    }
    
    static func extractSelectedCategoryIDs(from html: String) -> [Int] {

        let pattern =
        #"name="user\[interested_category_ids\]\[\]"[^>]*value="(\d+)"[^>]*checked|checked[^>]*name="user\[interested_category_ids\]\[\]"[^>]*value="(\d+)"#

        guard let regex = try? NSRegularExpression(pattern: pattern)
        else {
            return []
        }

        let matches = regex.matches(
            in: html,
            range: NSRange(html.startIndex..., in: html)
        )

        return matches.compactMap { match in

            for index in 1...2 {

                if let range = Range(match.range(at: index), in: html),
                   let id = Int(html[range]) {
                    return id
                }
            }

            return nil
        }
    }
    
    static func extractAvatarURL(from html: String) -> String? {

        let pattern = #"src="([^"]+square_150[^"]+)""#

        guard let regex = try? NSRegularExpression(pattern: pattern),
              let match = regex.firstMatch(
                in: html,
                range: NSRange(html.startIndex..., in: html)
              ),
              let range = Range(match.range(at: 1), in: html)
        else {
            return nil
        }

        return String(html[range])
    }
}
