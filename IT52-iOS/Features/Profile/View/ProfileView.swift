//
//  ProfileView.swift
//  IT52-iOS
//
//  Created by Полина Терехина on 06.07.2026.
//

import SwiftUI

struct ProfileView: View {
    
    @Environment(AuthViewModel.self)
    private var authViewModel
    
    var body: some View {
        NavigationStack{
            if authViewModel.isAuthenticated {
                UserProfileView()
            } else {
                GuestProfileView()
            }
        }
    }
}

#Preview {
    ProfileView()
}
