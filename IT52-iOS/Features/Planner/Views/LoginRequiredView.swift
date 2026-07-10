//
//  LoginRequiredView.swift
//  IT52-iOS
//
//  Created by Полина Терехина on 07.07.2026.
//

import SwiftUI

struct LoginRequiredView: View {
    
    @State private var showLogin = false
    
    var body: some View {
        
        VStack(spacing: AppTheme.largeSpacing) {
            
            Spacer()
            
            Image(systemName: "calendar.badge.exclamationmark")
                .font(.system(size: 80))
                .foregroundStyle(AppColors.accent)
            
            Text("Календарь недоступен")
                .font(AppFonts.title)
            
            VStack(spacing: AppTheme.smallSpacing) {
                
                Text("Войдите в аккаунт")
                    .font(AppFonts.title)
                
                Text("""
                    Для доступа к календарю и личному профилю - небоходимо авторизироваться.
                    """)
                .foregroundStyle(AppColors.textSecondary)
                .multilineTextAlignment(.center)
                
                Button{
                    
                    showLogin = true
                } label: {
                    
                    Text("Войти")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                
                Spacer()
            }
            .padding()
            .navigationTitle("Календарь")
            .sheet(isPresented: $showLogin) {
                
                LoginView()
            }
        }
    }
    
}

#Preview {
    LoginRequiredView()
}
