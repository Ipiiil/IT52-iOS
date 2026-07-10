//
//  ProfileSettingSection.swift
//  IT52-iOS
//
//  Created by Полина Терехина on 10.07.2026.
//

import SwiftUI

struct ProfileSettingSection: View {
    
    @Binding var profile: UserProfile
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 18) {
            
            Text("Настройки")
                .font(AppFonts.title)
            
            Toggle("Скрыть мой аккаунт",
                   isOn: $profile.isPrivate)
            
            Toggle("Получать уведомления о мероприятиях",
                   isOn: $profile.notificationsEnabled)
        }
    }
}

#Preview {
    @Previewable @State var profile = UserProfile()
    ProfileSettingSection(profile: $profile)
}
