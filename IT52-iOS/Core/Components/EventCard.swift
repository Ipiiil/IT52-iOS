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
                
                Text(EventTextCleaner.clean(event.title))
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
                
                Image(systemName: "mappin.and.ellipse")
                
                Text(event.location)
            }
            .font(AppFonts.caption)
            
            HStack {
                
                Image(systemName: "person.circle")
                
                Text(event.organized)
            }
            .font(AppFonts.caption)
            
            Text(EventTextCleaner.shortDescription(event.description))
                .font(AppFonts.body)
            
            
            if !event.tagList.isEmpty {
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(event.tagList.sorted(), id: \.self) { tag in
                            Text(tag)
                                .font(.caption)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(AppColors.accent.opacity(0.15)
                                )
                                .clipShape(Capsule())
                        }
                    }
                }
            }
            
        }
        .padding()
        .frame(maxWidth: .infinity,alignment: .leading)
        .background(AppColors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.cornerRadius))
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
