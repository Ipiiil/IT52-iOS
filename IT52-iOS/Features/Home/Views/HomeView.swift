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
                    //о сообществе
                    VStack(alignment: .leading, spacing: AppTheme.mediumSpacing) {
                        
                        SectionHeader(title: "О сообществе")
                        
                        Text("""
                            it52 — это некоммерческое сообщество энтузиастов, которые думают, что могут сделать жизнь нижегородского айтишника немного лучше. Мы помогаем организовывать профильные мероприятия, ведём афишу событий, курируем несколько чатиков в телеграме и групп в соцсетях, и кажется, что у нас получается.
                            """)
                        .font(AppFonts.body)
                        
                    }
                    
                    //Контакты
                    VStack(alignment: .leading, spacing: AppTheme.smallSpacing) {
                        
                        SectionHeader(title: "Контакты")
                        
                        Link(destination: URL(string: "https://it52.info")!){
                            Label("it52.info", systemImage: "globe")
                        }
                        
                        Link(destination: URL(string: "https://github.com/NNRUG/it52-rails")!){
                            Label("GitHub", systemImage: "link")
                        }
                        
                        Link(destination: URL(string: "https://t.me/it52info")!){
                            Label("Telegram", systemImage: "paperplane")
                        }
                        
                        Link(destination: URL(string: "mailto:info@it52.info")!){
                            Label("info@it52.info", systemImage: "envelope")
                        }
                        
                    }
                    .font(AppFonts.body)
                   
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
