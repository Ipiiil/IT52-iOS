//
//  PersonalInfoSection.swift
//  IT52-iOS
//
//  Created by Полина Терехина on 10.07.2026.
//

import SwiftUI

struct PersonalInfoSection: View {
    
    @Binding var profile: UserProfile
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 18){
            
            Text("Основная информация")
                .font(AppFonts.title)
            
            Group{
                
                TextField("Имя", text: $profile.firstName)
                
                TextField("Фамилия", text: $profile.lastName)
                
                TextField("Нинейм", text: $profile.nickname)
                
                TextField("Email", text: $profile.email)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                
                TextField("Место работы", text: $profile.employmet)
                
                TextField("Сайт", text: $profile.website)
                    .textInputAutocapitalization(.never)
            }
            .textFieldStyle(.roundedBorder)
        }
    }
}
