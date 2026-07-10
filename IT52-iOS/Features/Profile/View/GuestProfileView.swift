//
//  GuestProfileView.swift
//  IT52-iOS
//
//  Created by Полина Терехина on 09.07.2026.
//

import SwiftUI

struct GuestProfileView: View {
    
    @State private var showLogin = false
    
    var body: some View {
        
        VStack(spacing: 16) {
            Spacer()
            
            Image(systemName: "person.crop.circle.badge.questionmark")
                .font(.system(size: 80))
                .foregroundStyle(AppColors.accent)
            
            Text("Добро пожаловать!")
                .font(AppFonts.title)
            
            Text("""
                Войдите в аккаунт, чтобы:
                - пользоваться календарем
                - управлять своим профилем
                """)
            .multilineTextAlignment(.center)
            .font(AppFonts.body)
            .foregroundStyle(.secondary)
            
            Button {
                
                showLogin = true
                
            }label: {
                Text("Войти")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            
            NavigationLink("Нет аккаунта? Зарегистрируйся") {
                RegisterView()
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle("Профиль")
        .sheet(isPresented: $showLogin) {
            LoginView()
        }
    }
}

#Preview{
    GuestProfileView()
}
