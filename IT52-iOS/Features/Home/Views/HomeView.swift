//
//  HomeView.swift
//  IT52-iOS
//
//  Created by Полина Терехина on 06.07.2026.
//
import SwiftUI

struct HomeView: View {
    
    private var upcomingEvents: [Event] {
        
        Array(MockData.events.prefix(2))
        
    }
    var body: some View {
                
        NavigationStack {
            
            ScrollView {
                
                VStack(alignment: .leading, spacing: AppTheme.largeSpacing) {
                    
                    //приветствие
                    VStack(alignment: .leading, spacing: 4) {
                        
                        Text("Привет!")
                            .font(AppFonts.largeTitle)
                        
                        Text("Добро пожаловать в IT52")
                            .font(AppFonts.caption)
                            .foregroundStyle(AppColors.textSecondary)
                    }
                    
                    //ближайшие меро
                    VStack(alignment: .leading, spacing: AppTheme.mediumSpacing) {
                        
                        Text("Ближайшие события")
                            .font(AppFonts.headline)
                        
                        ForEach(upcomingEvents) { event in EventCard(event: event)}
                    }
                    
                    //популярные ( пока заглушка)
                    VStack(alignment: .leading, spacing: AppTheme.mediumSpacing) {
                        
                        Text("Популярные")
                            .font(AppFonts.headline)
                        
                        Text("Скоро появится...")
                            .font(AppFonts.caption)
                            .foregroundStyle(AppColors.textSecondary)
                    }
                    
                    //новости ( пока заглушка)
                    VStack(alignment: .leading, spacing: AppTheme.mediumSpacing) {
                        
                        Text("Новости")
                            .font(AppFonts.headline)
                        
                        Text("Скоро появится...")
                            .font(AppFonts.caption)
                            .foregroundStyle(AppColors.textSecondary)
                    }
                   
                }
                .padding()
            }
            .navigationTitle("IT52")
        }
    }
}

#Preview {
    HomeView()
}
