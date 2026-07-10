//
//  InterestsChip.swift
//  IT52-iOS
//
//  Created by Полина Терехина on 10.07.2026.
//

import SwiftUI

struct InterestsChip: View {
    
    let title: String
    
    let isSelected: Bool
    
    let action: () -> Void
    
    var body: some View {
        
        Button(action: action) {
            
            HStack(spacing: 2) {
                
                if isSelected{
                    
                    Image(systemName: "checkmark")
                }
                
                Text(title)
            }
            .font(.subheadline.weight(.medium))
            .padding(.horizontal, 10)
            .padding(.vertical, 10)
            .background(
                isSelected
                ? AppColors.accent
                : AppColors.cardBackground
            )
            .foregroundStyle(
                
                isSelected
                ? Color.white
                : AppColors.textPrimary
                
            )
            .clipShape(Capsule())
            
        }
        .buttonStyle(.plain)
    }
}
