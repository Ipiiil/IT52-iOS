//
//  HomeView.swift
//  IT52-iOS
//
//  Created by Полина Терехина on 06.07.2026.
//
import SwiftUI

struct HomeView: View {
    
    var body: some View {
        
        ScrollView{
            
            //выстраиваем вертикально
            VStack(alignment: .leading, spacing: AppTheme.largeSpacing){
                
                Text("Главная")
                    .font(AppFonts.largeTitle)
                    .foregroundStyle(AppColors.textPrimary)
            }
            .padding(.horizontal, AppTheme.horizontalPadding)
            .padding(.top)
            
        }
        .background(AppColors.background)
        
    }
}

#Preview {
    HomeView()
}
