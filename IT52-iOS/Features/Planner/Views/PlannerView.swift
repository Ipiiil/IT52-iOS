//
//  PlannerView.swift
//  IT52-iOS
//
//  Created by Полина Терехина on 06.07.2026.
//

import SwiftUI

struct PlannerView: View {
    
    @State private var appState = AppState()
    @State private var selectedDate = Date()
    
    //все мероприятия пользвоателя
    private var myEvents: [Event] {
        
        MockData.events.filter { $0.isRegistered }
    }
    
    //мероприятия выбранного дня
    private var selectedDayEvents: [Event] {
        
        myEvents.filter {
            Calendar.current.isDate(
                $0.date,
                inSameDayAs: selectedDate
            )
        }
    }

    var body: some View {
        
        NavigationStack {
            
            if appState.isAuthorized {
                
                ScrollView {
                
                VStack(alignment: .leading, spacing: AppTheme.largeSpacing) {
                    
                    DatePicker(
                        "Выберите дату",
                        selection: $selectedDate,
                        displayedComponents: .date
                    )
                    .datePickerStyle(.graphical)
                    
                    
                    VStack(alignment: .leading,
                           spacing: AppTheme.mediumSpacing) {
                        
                        
                        Text("Мои мероприятия (\(myEvents.count))")
                            .font(AppFonts.headline)
                        
                        if selectedDayEvents.isEmpty {
                            
                            Text("У вас пока нет мероприятий")
                                .font(AppFonts.caption)
                                .foregroundStyle(
                                    AppColors.textSecondary
                                )
                            
                        } else {
                            
                            ForEach(selectedDayEvents) { event in
                                
                                NavigationLink {
                                    
                                    EventDetailView(event: event)
                                } label: {
                                    
                                    EventCard(event: event)
                                }
                                .buttonStyle(.plain)
                                
                            }
                            
                        }
                        
                    }
                    
                    
                }
                .padding()
                
            }
                .navigationTitle("Календарь")
            
        } else {
            LoginRequiredView()
                .navigationTitle("Календарь")
        }
    }
}
}


#Preview {
   PlannerView()
}
