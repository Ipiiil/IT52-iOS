//
//  GuestProfileView.swift
//  IT52-iOS
//
//  Created by Полина Терехина on 09.07.2026.
//

import SwiftUI

struct GuestProfileView: View {
    
    var body: some View {
        
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "person.crop.circle.badge.questionmark")
                .font(.system(size: 80))
                .foregroundStyle(AppColors.accent)
            
            Text("Добро пожаловать!")
                .font(AppFonts.title)
            
            Text("""
                Войдите в аккаунт, чтобы:
                - пользоваться календарем
                - записываться на мероприятия
                - управлять своим профилем
                """)
            .multilineTextAlignment(.center)
            .font(AppFonts.body)
            .foregroundStyle(.secondary)
            
            Button {
                
            }label: {
                Text("Войти")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            
            Button("Зарегестрироваться") {
                
            }
            Spacer()
        }
        .padding()
        .navigationTitle("Профиль")
    }
}

#Preview{
    GuestProfileView()
}
