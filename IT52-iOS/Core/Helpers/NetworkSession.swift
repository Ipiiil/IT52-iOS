//
//  NetworkSession.swift
//  IT52-iOS
//
//  Created by Полина Терехина on 14.07.2026.
//

import Foundation

final class NetworkSession {
    static let shared: URLSession = {

        let configuration = URLSessionConfiguration.default

        configuration.httpCookieStorage = HTTPCookieStorage.shared
        configuration.httpShouldSetCookies = true
        configuration.httpCookieAcceptPolicy = .always

        return URLSession(
            configuration: configuration,
            delegate: NoRedirectDelegate(),
            delegateQueue: nil
        )

    }()
}
