//
//  ProfileService.swift
//  IT52-iOS
//
//  Created by Полина Терехина on 14.07.2026.
//

import Foundation

final class ProfileService {
    
    private let baseURL = URL(string: "https://it52.info")!
    private let redirectDelegate = NoRedirectDelegate()
    
    
    private let session = NetworkSession.shared
    /*private lazy var session: URLSession = {
        URLSession(configuration: .default, delegate: redirectDelegate, delegateQueue: nil)
    }()*/
    
    // Читаем текущий профиль с сайта
    func fetchProfile() async throws -> UserProfile {
        
        let url = baseURL.appendingPathComponent("my/profile/edit")
        let (data, _) = try await URLSession.shared.data(from: url)
        
        guard let html = String(data: data, encoding: .utf8) else {
            throw AuthError.unexpectedResponse
        }
        
        var profile = UserProfile()
        profile.firstName = WebFormHelper.extractInputValue(name: "user[first_name]", from: html) ?? ""
        profile.lastName = WebFormHelper.extractInputValue(name: "user[last_name]", from: html) ?? ""
        profile.nickname = WebFormHelper.extractInputValue(name: "user[nickname]", from: html) ?? ""
        profile.employmet = WebFormHelper.extractInputValue(name: "user[employment]", from: html) ?? ""
        profile.website = WebFormHelper.extractInputValue(name: "user[website]", from: html) ?? ""
        profile.bio = WebFormHelper.extractTextareaValue(name: "user[bio]", from: html) ?? ""
        profile.isPrivate = WebFormHelper.extractCheckboxChecked(name: "user[hidden]", from: html)
        profile.notificationsEnabled = WebFormHelper.extractCheckboxChecked(name: "user[subscription]", from: html)
        profile.interestedCategoryIDs = WebFormHelper.extractSelectedCategoryIDs(from: html)
        if let url = WebFormHelper.extractAvatarURL(from: html) {
            profile.avatarURL = url + "?t=\(Date().timeIntervalSince1970)"
        }
        print("AVATAR URL:", profile.avatarURL ?? "nil")
        return profile
    }
    
    // Отправляем изменения на сайт
    func updateProfile(_ profile: UserProfile, avatarImageData: Data?) async throws {
        
        let editPageURL = baseURL.appendingPathComponent("my/profile/edit")
        let (pageData, _) = try await session.data(from: editPageURL)
        let csrfToken = try WebFormHelper.extractCSRFToken(from: pageData)
        
        let boundary = "Boundary-\(UUID().uuidString)"
        
        var fields: [(String, String)] = [
            ("_method", "patch"),
            ("authenticity_token", csrfToken),
            ("user[first_name]", profile.firstName),
            ("user[last_name]", profile.lastName),
            ("user[nickname]", profile.nickname),
            ("user[employment]", profile.employmet),
            ("user[website]", profile.website),
            ("user[bio]", profile.bio),
            ("user[hidden]", profile.isPrivate ? "1" : "0"),
            ("user[subscription]", profile.notificationsEnabled ? "1" : "0")
        ]
        
        if profile.interestedCategoryIDs.isEmpty{
            fields.append(("user[interested_category_ids][]", ""))
        } else {
            
            for id in profile.interestedCategoryIDs {
                fields.append(("user[interested_category_ids][]", String(id)))
            }
        }
        
        
        let body = WebFormHelper.multipartBody(
            fields: fields,
            fileField: avatarImageData != nil ? "user[avatar_image]" : nil,
            fileData: avatarImageData,
            fileName: "avatar_\(UUID().uuidString).jpg",
            mimeType: "image/jpeg",
            boundary: boundary
        )
        
        var request = URLRequest(url: baseURL.appendingPathComponent("my/profile"))
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.httpBody = body
        
        let (data, response) = try await session.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw AuthError.unexpectedResponse
        }
        
        switch httpResponse.statusCode {
        case 302:
            // успех — Rails обновил профиль и редиректит на /my/profile
            return
        case 200:
            let errorDetail = extractFlashError(from: data) ?? "неизвестная причина"
            print("DEBUG: сохранение профиля не удалось — \(errorDetail)")
            throw AuthError.unexpectedResponse

        default:
            throw AuthError.unexpectedResponse
        }
    }
    
    private func extractFlashError(from data: Data) -> String? {
        guard let html = String(data: data, encoding: .utf8) else { return nil }
        let pattern = #"<div class="alert[^"]*">(.*?)</div>"#
        guard let regex = try? NSRegularExpression(pattern: pattern, options: .dotMatchesLineSeparators),
              let match = regex.firstMatch(in: html, range: NSRange(html.startIndex..., in: html)),
              let range = Range(match.range(at: 1), in: html) else {
            return nil
        }
        return String(html[range])
            .replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression)
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
