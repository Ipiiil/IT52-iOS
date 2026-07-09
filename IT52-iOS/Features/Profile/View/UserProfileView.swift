//
//  UserProfileView.swift
//  IT52-iOS
//
//  Created by Полина Терехина on 09.07.2026.
//
import SwiftUI

struct UserProfileView: View {
    @Environment(AuthViewModel.self)
    private var authViewModel
    
    var body: some View {
        
        List {
            Section{
                Text(authViewModel.currentUser?.name ?? "")
                
                Text(authViewModel.currentUser?.email ?? "")
                    .foregroundStyle(.secondary)
            }
            
            Button("Выйти") {
                authViewModel.logout()
            }
            .foregroundStyle(.red)
        }
        .navigationTitle("Профиль")
    }
    
}

#Preview {
    UserProfileView()
}
