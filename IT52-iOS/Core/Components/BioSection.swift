//
//  BioSection.swift
//  IT52-iOS
//
//  Created by Полина Терехина on 10.07.2026.
//

import SwiftUI

struct BioSection: View {
    
    @Binding var profile: UserProfile
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 12){
            
            Text("О себе")
                .font(AppFonts.title)
            
            TextEditor(text: $profile.bio)
                .frame(minHeight: 140)
                .padding()
                .background(AppColors.cardBackground)
            
            
        }
    }
}

#Preview {
    @Previewable @State var profile = UserProfile()
    
    BioSection(profile: $profile)
}
