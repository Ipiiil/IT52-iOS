//
//  LoginRequiredView.swift
//  IT52-iOS
//
//  Created by Полина Терехина on 07.07.2026.
//

import SwiftUI

struct LoginRequiredView: View {
    
    var body: some View {
        
        VStack(spacing: AppTheme.largeSpacing) {
            
            Spacer()
            
            Image(systemName: "person.crop.circle.badge.exclamationark")
                .font(.system(size: 70))
                .foregroundStyle(AppColors.accent)
            
            VStack(spacing: AppTheme.smallSpacing) {
                
                Text("Войдите в аккаунт")
                    .font(AppFonts.title)
                
                Text("""
                    Для доступа к календарю и личному профилю - небоходимо авторизироваться.
                    """)
                .font(AppFonts.body)
                .foregroundStyle(AppColors.textSecondary)
                .multilineTextAlignment(.center)
            }
            
            VStack (spacing: AppTheme.mediumSpacing) {
                
                Button {
                    
                } label: {
                    
                    Label ("Войти через VK", systemImage: "person.badge.key")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                
                Button{
                    
                } label: {
                    Text("Зарегистрироваться")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
            }
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    LoginRequiredView()
}
