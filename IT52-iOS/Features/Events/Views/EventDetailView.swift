//
//  EventDetailView.swift
//  IT52-iOS
//
//  Created by Полина Терехина on 07.07.2026.
//
import SwiftUI

struct EventDetailView: View{
    
    let event: Event
    
    var body: some View {
        
        ScrollView {
            
            VStack(alignment: .leading, spacing: AppTheme.largeSpacing) {
                
                RoundedRectangle(cornerRadius: AppTheme.cornerRadius)
                    .fill(AppColors.cardBackground)
                    .frame(height: 220)
                    .overlay{
                        
                        Image(systemName: "photo")
                            .font(.largeTitle)
                        
                    }
                
                VStack(alignment: .leading, spacing: AppTheme.mediumSpacing) {
                    
                    Text(event.title)
                        .font(AppFonts.largeTitle)
                    
                    HStack{
                        
                        Image(systemName: "calendar")
                        
                        Text(event.date.formatted(date: .long, time: .shortened))
                    }
                    
                    HStack{
                        
                        Image(systemName: "mapping.and.ellipse")
                        
                        Text(event.location)
                        
                    }
                    
                    HStack{
                        
                        Image(systemName: "person.circle")
                        
                        Text(event.organized)
                    }
                    
                    Text(event.description)
                    
                }
                
                Button{
                } label: {
                    
                    Text("Записаться")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                
            }
            .padding()
        }
        .navigationTitle("События")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    
    NavigationStack {
        
        EventDetailView(event: MockData.events[0])
    }
}
