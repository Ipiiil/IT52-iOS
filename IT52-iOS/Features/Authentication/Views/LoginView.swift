//
//  LoginView.swift
//  IT52-iOS
//
//  Created by Полина Терехина on 09.07.2026.
//

import SwiftUI

struct LoginView: View {
    @Environment(AuthViewModel.self)
    private var authViewModel
    
    @Environment(\.dismiss)
    private var dismiss
    
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        
        NavigationStack {
            ScrollView {
                VStack(spacing: 28) {
                    
                    Spacer()
                        .frame(height: 30)
                    
                    Image(systemName: "person.crop.circle.fill")
                        .font(.system(size: 80))
                        .foregroundStyle(AppColors.accent)
                    
                    Text("Добро пожаловать!")
                        .font(AppFonts.title)
                    
                    Text("Войдите, чтобы пользоваться всеми возможностями IT52.")
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.secondary)
                    
                    VStack(spacing: 16) {
                        TextField("Email", text: $email)
                            .textInputAutocapitalization(.never)
                            .keyboardType(.emailAddress)
                            .padding()
                            .background(AppColors.cardBackground)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        
                        SecureField("Пароль", text: $password)
                            .padding()
                            .background(AppColors.cardBackground)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        
                    }
                    
                    Button{
                        Task {
                            
                            await authViewModel.login(
                                email: email,
                                password: password
                            )
                            dismiss()
                        }
                    } label: {
                        if authViewModel.isLoading{
                            ProgressView()
                        } else {
                            
                            Text("Войти")
                                .frame(maxWidth: .infinity)
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    
                    NavigationLink("Нет аккаунта? Зарегистрироваться") {
                        
                        RegisterView()
                        
                    }
                    Spacer()
                    
                }
                .padding()
                .navigationTitle("Вход")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}

#Preview{
    LoginView()
}
