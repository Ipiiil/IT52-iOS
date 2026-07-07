//
//  SearchBar.swift
//  IT52-iOS
//
//  Created by Полина Терехина on 07.07.2026.
//
import SwiftUI

struct SearchBar: View {
    
    @Binding var text: String
    
    var body: some View {
        
        HStack {
            
            Image(systemName: "magnifyingglass")
            
            TextField("Поиск мероприятия", text: $text)
            
        }
        .padding(12)
        .background(AppColors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.cornerRadius))
    }
}
