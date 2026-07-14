//
//  PlannerView.swift
//  IT52-iOS
//
//  Created by Полина Терехина on 06.07.2026.
//

import SwiftUI

struct PlannerView: View {
    
    @Environment(AuthViewModel.self) private var authViewModel
    @Environment(EventsViewModel.self) private var eventsViewModel
    @Environment(AttendanceStore.self) private var attendanceStore
    @State private var selectedDate = Date()
    
    //все мероприятия отмеченные "иду"
    private var myEvents: [Event] {
        
        eventsViewModel.events
            .filter {attendanceStore.isAttending($0)}
            .sorted{ $0.date < $1.date}
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
    
    private var datesWithEvents: Set<String> {
        
            Set(
                myEvents.map {
                    EventsPlannerView.dayKey($0.date) })
        }

    var body: some View {
            
        NavigationStack {
            
            if authViewModel.isAuthenticated {
                
                ScrollView {
                    
                    VStack(alignment: .leading, spacing: AppTheme.largeSpacing) {
                        
                        EventsPlannerView(
                            selectedDate: $selectedDate,
                            datesWithEvents: datesWithEvents
                        )
                        .frame(height: 400)
                        .padding(.top, AppTheme.largeSpacing)
                        .padding(.bottom, AppTheme.largeSpacing)
                        
                        
                        
                        VStack(alignment: .leading,
                               spacing: AppTheme.mediumSpacing) {
                            
                            
                            Text("На \(selectedDate.formatted(date: .long, time: .omitted)) (\(selectedDayEvents.count))")
                                .font(AppFonts.headline)
                            
                            
                            if selectedDayEvents.isEmpty {
                                
                                
                                Text("У вас пока нет мероприятий на этот день")
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
    NavigationStack {
        PlannerView ()
            .environment(EventsViewModel())
            .environment(AttendanceStore())
            .environment(AuthViewModel())
        }
    }

