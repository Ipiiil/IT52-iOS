//
//  TabBarView.swift
//  IT52-iOS
//
//  Created by Полина Терехина on 06.07.2026.
//

import SwiftUI

struct TabBarView: View {
    var body: some View {
        TabView{
            NavigationStack{
                HomeView()
            }
            .tabItem{
                Label("Главная", systemImage: "house.fill")
            }
            
            NavigationStack {
                PlannerView()
            }
            .tabItem{
                Label("Планы", systemImage: "calendar")
            }
            
            NavigationStack {
                EventsView()
            }
            .tabItem{
                Label("События", systemImage: "ticket.fill")
            }
            
            NavigationStack {
                ProfileView()
            }
            .tabItem{
                Label("Профиль", systemImage: "person.fill")
            }
        }
        .tint(AppColors.accent) // переопределение глобального accent для конкретного представления элементов
    }
}

#Preview {
    TabBarView()
}
