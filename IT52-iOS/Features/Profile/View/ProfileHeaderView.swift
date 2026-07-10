//
//  ProfileHeaderView.swift
//  IT52-iOS
//
//  Created by Полина Терехина on 10.07.2026.
//

import SwiftUI

struct ProfileHeaderView: View {
    
    var body: some View {
        
        VStack(spacing: 16) {
            
            Image(systemName: "person.crop.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width:120, height:120)
                .foregroundStyle(AppColors.accent)
            
            Button("Изменить фото") {
                
            }
            .font(AppFonts.caption)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    ProfileHeaderView()
}
