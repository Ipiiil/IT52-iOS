//
//  AuthViewModel.swift
//  IT52-iOS
//
//  Created by Полина Терехина on 09.07.2026.
//
import Foundation
import Observation

@Observable
final class AuthViewModel{
    var currentUser: User?
    
    var isLoading = false
    
    var errorMessage: String?
    
    var isAutheticated: Bool {
        currentUser != nil
    }
    
    private let service = AuthService()
    
    func login(email: String,
               password: String) async {
        
        isLoading = true
        do {
            currentUser = try await service.login(
                email:email,
                password: password
            )
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
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func logout() {
        currentUser = nil
    }
}
