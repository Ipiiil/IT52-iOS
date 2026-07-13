//
//  HomeView.swift
//  IT52-iOS
//
//  Created by Полина Терехина on 06.07.2026.
//
import SwiftUI

struct HomeView: View {
    
    @Environment(EventsViewModel.self) private var viewModel
    
    private var upcomingEvents: [Event] {
        viewModel.events
            .filter { $0.date >= .now}
            .sorted {$0.date < $1.date}
            .prefix(2)
            .map{$0}
        
    }
    var body: some View {
            
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
                        
                        if viewModel.isLoading && viewModel.events.isEmpty {
                            
                            ProgressView()
                            
                        } else if upcomingEvents.isEmpty {
                            
                            Text("Нет предстоящих событий")
                                .font(AppFonts.caption)
                                .foregroundStyle(AppColors.textSecondary)
                        } else {
                            
                            ForEach(upcomingEvents) {event in
                                NavigationLink {
                                    EventDetailView(event: event)
                                } label : {
                                    EventCard(event: event)
                                }
                                .buttonStyle(.plain)
                            }
                        }
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
                    VStack(alignment: .leading, spacing: AppTheme.mediumSpacing) {
                        
                        SectionHeader(title: "Контакты")
                        
                        Link(destination: URL(string: "https://it52.info/")!){
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
                        
                        Link(destination: URL(string: "https://hub.docker.com/r/it52/rails")!){
                            Label("Docker", systemImage: "network")
                        }
                        
                        
                    }
                    .font(AppFonts.body)
                   
                }
                .padding()
            }
            .navigationTitle("IT52")
            .task{
                if viewModel.events.isEmpty {
                    await viewModel.loadEvents()
                }
            }
        }
    }

#Preview {
    NavigationStack {
        HomeView()
            .environment(EventsViewModel())
    }
}
