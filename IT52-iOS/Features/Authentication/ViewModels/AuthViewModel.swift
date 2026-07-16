//
//  AuthViewModel.swift
//  IT52-iOS
//
//  Created by Полина Терехина on 09.07.2026.
//
import Foundation
import Observation

@MainActor
@Observable
final class AuthViewModel{
    var currentUser: User?
    
    var isLoading = false
    
    var errorMessage: String?
    
    var isAuthenticated: Bool {
        currentUser != nil
    }
    
    private let service = AuthService()
    
    //восстановление сессии
    init() {
        if let data = UserDefaults.standard.data(forKey: "currentUser"),
           let user = try? JSONDecoder().decode(User.self, from: data) {
            currentUser = user
        }
    }
    
    func login(email: String,
               password: String) async {
        
        isLoading = true
        do {
            currentUser = try await service.login(
                email:email,
                password: password
            )
            
            if let currentUser {
                let data = try JSONEncoder().encode(currentUser)
                UserDefaults.standard.set(data, forKey: "currentUser")
            }
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
    
    func register(name: String,
                  email: String,
                  password: String) async {
        
        isLoading = true
        do {
            currentUser = try await service.register(
                name: name,
                email: email,
                password: password
            )
            
            if let currentUser{
                let data = try JSONEncoder().encode(currentUser)
                UserDefaults.standard.set(data, forKey: "currentUser")
            }
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func logout() {

        currentUser = nil

        UserDefaults.standard.removeObject(forKey: "currentUser")
        service.logout()
    }
}
