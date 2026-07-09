//
//  EventDetailView.swift
//  IT52-iOS
//
//  Created by Полина Терехина on 07.07.2026.
//
import SwiftUI

struct EventDetailView: View{
    
    let event: Event
    
    @Environment(AttendanceStore.self) private var attendanceStore
    @Environment(AppState.self) private var appState
    
    var body: some View {
        
        ScrollView {
            
            VStack(alignment: .leading, spacing: AppTheme.largeSpacing) {
                
                eventImage
                    .frame(height: 220)
                    .frame(maxWidth: .infinity)
                    .clipShape(RoundedRectangle(cornerRadius: AppTheme.cornerRadius))
                
                
                VStack(alignment: .leading, spacing: AppTheme.mediumSpacing) {
                    
                    Text(event.title)
                        .font(AppFonts.largeTitle)
                    
                    HStack{
                        
                        Image(systemName: "calendar")
                        
                        Text(event.date.formatted(date: .long, time: .shortened))
                    }
                    
                    HStack{
                        
                        Image(systemName: "mappin.and.ellipse")
                        
                        Text(event.location)
                        
                    }
                    
                    HStack{
                        
                        Image(systemName: "person.circle")
                        
                        Text(event.organized)
                    }
                    
                    Text(event.description)
                    
                }
                
                if appState.isAuthorized {
                    Button {
                        attendanceStore.toggleAttendance(for: event)
                    } label: {
                        Label (
                            attendanceStore.isAttending(event) ? "Иду" : "Отметить, что иду",
                            systemImage: attendanceStore.isAttending(event) ? "checkmark.circle.fill" : "circle"
                        )
                        .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(attendanceStore.isAttending(event) ? .green : AppColors.accent)
                } else {
                    Text("Войдите, чтобы отмечать события")
                        .font(AppFonts.caption)
                        .foregroundStyle(AppColors.textSecondary)
                }
                /*Button{
                } label: {
                    
                    Text("Записаться")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)*/
                
            }
            .padding()
        }
        .navigationTitle("События")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    @ViewBuilder
        private var eventImage: some View {

            if let imageURL = event.imageURL, let url = URL(string: imageURL) {

                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)

                    case .failure:
                        placeholderImage

                    case .empty:
                        ZStack {
                            RoundedRectangle(cornerRadius: AppTheme.cornerRadius)
                                .fill(AppColors.cardBackground)
                            ProgressView()
                        }

                    @unknown default:
                        placeholderImage
                    }
                }

            } else {
                placeholderImage
            }
        }

        private var placeholderImage: some View {
            RoundedRectangle(cornerRadius: AppTheme.cornerRadius)
                .fill(AppColors.cardBackground)
                .overlay {
                    Image(systemName: "photo")
                        .font(.largeTitle)
                }
        }
    }

#Preview {
    NavigationStack {
        EventDetailView(event: MockData.events[0])
            .environment(AttendanceStore())
            .environment(AppState())
        
    }
}
