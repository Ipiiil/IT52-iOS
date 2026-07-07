//
//  EventsView.swift
//  IT52-iOS
//
//  Created by Полина Терехина on 06.07.2026.
//

import SwiftUI

struct EventsView: View {
    
    @State private var searchText = ""
    
    private var filteredEvents: [Event] {
        
        if searchText.isEmpty {
            
            return MockData.events
        }
        
        return MockData.events.filter {
            $0.title.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    var body: some View {
        
        NavigationStack {
            
            ScrollView {
                
                VStack(alignment: .leading, spacing: AppTheme.mediumSpacing) {
                    
                    SearchBar(text: $searchText)
                    
                    Text("Все события")
                        .font(AppFonts.headline)
                    
                    ForEach(filteredEvents) { event in
                        
                        NavigationLink {
                            
                            EventDetailView(event: event)
                        } label: {
                            
                            EventCard(event: event)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding()
            }
            .navigationTitle("События")
        }
    }
}

#Preview {
    EventsView()
}
