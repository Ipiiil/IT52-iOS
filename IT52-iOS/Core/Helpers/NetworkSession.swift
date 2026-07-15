//
//  NetworkSession.swift
//  IT52-iOS
//
//  Created by Полина Терехина on 14.07.2026.
//

import Foundation

final class NetworkSession {
    static let shared = URLSession(
        configuration: .default,
        delegate: NoRedirectDelegate(),
        delegateQueue: nil
    )
}
