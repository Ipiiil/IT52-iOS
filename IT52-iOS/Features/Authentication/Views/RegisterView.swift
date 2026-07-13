//
//  RegisterView.swift
//  IT52-iOS
//
//  Created by Полина Терехина on 10.07.2026.
//

import SwiftUI

struct RegisterView: View {
    
    @Environment(AuthViewModel.self)
    private var authViewModel
    
    @Environment(\.dismiss)
    private var dismiss
    
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var repeatPassword = ""
    
    private var passwordsMismatch: Bool {
        !repeatPassword.isEmpty && password != repeatPassword
    }
    
    var body: some View {
        
        ScrollView {
            VStack(spacing: 24) {
                
                Spacer()
                    .frame(height: 30)
                
                Image(systemName: "person.badge.plus")
                    .font(.system(size: 80))
                    .foregroundStyle(AppColors.accent)
                
                Text("Создать аккаунт")
                    .font(AppFonts.title)
                
                Text("После регистрации вы сможете пользоваться календарем и управлять своим профилем")
                    .multilineTextAlignment(.center)
                    .font(AppFonts.body)
                    .foregroundStyle(.secondary)
                
                VStack(spacing: 16) {
                    
                    TextField("Имя", text: $name)
                        .padding()
                        .background(AppColors.cardBackground)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    
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
                    
                    SecureField("Повторите пароль", text: $repeatPassword)
                        .padding()
                        .background(AppColors.cardBackground)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    
                    if passwordsMismatch{
                        Text("Пароли не совпадают")
                            .font(AppFonts.caption)
                            .foregroundStyle(.red)
                    }
                    
                    if let error = authViewModel.errorMessage {
                        Text(error)
                            .font(AppFonts.caption)
                            .foregroundStyle(.red)
                    }
                }
                
                Button {
                    
                    guard password == repeatPassword else {
                        return
                    }
                    Task {
                        
                        await authViewModel.register(
                            name: name,
                            email: email,
                            password: password
                        )
                        if authViewModel.isAuthenticated{
                            dismiss()
                        }
                    }
                } label: {
                    
                    if authViewModel.isLoading {
                        
                        ProgressView()
                    } else {
                        
                        Text("Зарегистрироваться")
                            .frame(maxWidth: .infinity)
                    }
                }
                .buttonStyle(.borderedProminent)
                .disabled(name.isEmpty || email.isEmpty || password.isEmpty || passwordsMismatch)
                
            }
            .padding()
        }
        .navigationTitle("Регистрация")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack{
        RegisterView()
            .environment(AuthViewModel())
    }
}
