//
//  EventCard.swift
//  IT52-iOS
//
//  Created by Полина Терехина on 06.07.2026.
//
import SwiftUI

struct EventCard: View {
    
    let event: Event
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 12) {
            
            HStack(alignment: .top) {
                
                Text(event.title)
                    .font(AppFonts.headline)
                
                Spacer ()
                
                if event.isFavorite {
                    
                    Image(systemName: "heart.fill")
                        .foregroundStyle(.red)
                }
            }
            
            HStack {
                
                Image(systemName: "calendar")
                
                Text(event.date.formatted(date: .abbreviated,
                                          time: .omitted))
            }
            .font(AppFonts.caption)
            
            HStack {
                
                Image(systemName: ",apping.and.ellipse")
                
                Text(event.location)
            }
            .font(AppFonts.caption)
            
            Text(event.description)
                .font(AppFonts.body)
                .lineLimit(2)
            
            Text(event.category)
                .font(.caption)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(AppColors.accent.opacity(0.15))
                .clipShape(Capsule())
            
        }
        .padding()
        .frame(maxWidth: .infinity,alignment: .leading)
        .background(AppColors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.cornerRadius))
    }
}
