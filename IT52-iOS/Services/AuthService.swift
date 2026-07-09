//
//  AuthService.swift
//  IT52-iOS
//
//  Created by Полина Терехина on 09.07.2026.
//

import Foundation

final class AuthService{
    
    func login(email: String,
               password: String) async throws -> User {
        
        // Подключить АПИ авторизацию, если есть
        return User(
            id: UUID(),
            name: "Пользователь",
            email: email
        )
    }
    
    func register(name: String,
                  email: String,
                  password: String) async throws -> User{
        
        //подключить АПИ авторизацию, если есть
        
        return User(
            id: UUID(),
            name: name,
            email: email
        )
    }
}
