//
//  AuthService.swift
//  IT52-iOS
//
//  Created by Полина Терехина on 09.07.2026.
//

import Foundation

struct User: Codable {
    let email: String
    let name: String?
}

enum AuthError: LocalizedError {
    case csrfTokenNotFound
    case invalidCredentials
    case registrationFailed
    case unexpectedResponse

    var errorDescription: String? {
        switch self {
        case .csrfTokenNotFound: return "Не удалось подготовить форму, попробуйте ещё раз."
        case .invalidCredentials: return "Неверный email или пароль."
        case .registrationFailed: return "Не удалось зарегистрироваться. Проверьте данные."
        case .unexpectedResponse: return "Что-то пошло не так. Попробуйте позже."
        }
    }
}

final class AuthService {

    private let baseURL = URL(string: "https://it52.info")!
    private let redirectDelegate = NoRedirectDelegate()

    private lazy var session: URLSession = {
        URLSession(configuration: .default, delegate: redirectDelegate, delegateQueue: nil)
    }()

    private func fetchCSRFToken(path: String) async throws -> String {
        let url = baseURL.appendingPathComponent(path)
        let (data, _) = try await URLSession.shared.data(from: url)

        guard let html = String(data: data, encoding: .utf8) else {
            throw AuthError.csrfTokenNotFound
        }
        // HTML-тег, который сервер внедряет на страницу для защиты от CSRF-атак
        let pattern = #"<meta name="csrf-token" content="([^"]+)""#
        guard let regex = try? NSRegularExpression(pattern: pattern),
              let match = regex.firstMatch(in: html, range: NSRange(html.startIndex..., in: html)),
              let range = Range(match.range(at: 1), in: html) else {
            throw AuthError.csrfTokenNotFound
        }

        return String(html[range])
    }

    private func formEncode(_ params: [String: String]) -> Data {
        var allowedCharacters = CharacterSet.alphanumerics
        allowedCharacters.insert(charactersIn: "-._~")

        return params
            .map { key, value in
                let encodedKey = key.addingPercentEncoding(withAllowedCharacters: allowedCharacters) ?? key
                let encodedValue = value.addingPercentEncoding(withAllowedCharacters: allowedCharacters) ?? value
                return "\(encodedKey)=\(encodedValue)"
            }
            .joined(separator: "&")
            .data(using: .utf8) ?? Data()
    }

    func login(email: String, password: String) async throws -> User {
        let csrfToken = try await fetchCSRFToken(path: "login")

        var request = URLRequest(url: baseURL.appendingPathComponent("login"))
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = formEncode([
            "authenticity_token": csrfToken,
            "user[email]": email,
            "user[password]": password,
            "user[remember_me]": "1"
        ])

        let (_, response) = try await session.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw AuthError.unexpectedResponse
        }

        switch httpResponse.statusCode {
        case 302:
            let location = httpResponse.value(forHTTPHeaderField: "Location") ?? ""
            if location.contains("/login") {
                throw AuthError.invalidCredentials
            }
            return User(email: email, name: nil)
        case 200:
            throw AuthError.invalidCredentials
        default:
            throw AuthError.unexpectedResponse
        }
    }

    func register(name: String, email: String, password: String) async throws -> User {
        let csrfToken = try await fetchCSRFToken(path: "signup")

        var request = URLRequest(url: baseURL)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = formEncode([
            "authenticity_token": csrfToken,
            "user[email]": email,
            "user[password]": password,
            "user[password_confirmation]": password
        ])

        let (_, response) = try await session.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw AuthError.unexpectedResponse
        }

        switch httpResponse.statusCode {
        case 302:
            return User(email: email, name: name)
        case 200:
            throw AuthError.registrationFailed
        default:
            throw AuthError.unexpectedResponse
        }
    }

    func logout() {
        if let cookies = HTTPCookieStorage.shared.cookies {
            for cookie in cookies where cookie.domain.contains("it52.info") {
                HTTPCookieStorage.shared.deleteCookie(cookie)
            }
        }
    }
}

private final class NoRedirectDelegate: NSObject, URLSessionTaskDelegate {
    func urlSession(
        _ session: URLSession,
        task: URLSessionTask,
        willPerformHTTPRedirection response: HTTPURLResponse,
        newRequest request: URLRequest,
        completionHandler: @escaping (URLRequest?) -> Void
    ) {
        completionHandler(nil)
    }
}
