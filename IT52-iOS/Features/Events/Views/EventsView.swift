//
//  EventsView.swift
//  IT52-iOS
//
//  Created by Полина Терехина on 06.07.2026.
//

import SwiftUI

struct EventsView: View {
    
    @Environment(EventsViewModel.self) private var viewModel
    @State private var searchText = ""
    
    
    private var filteredEvents: [Event] {
        
        if searchText.isEmpty {
            
            return viewModel.events
        }
        
        return viewModel.events.filter {
            $0.title.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    var body: some View {
            
            ScrollView {
                
                LazyVStack(spacing: AppTheme.mediumSpacing) {

                    if viewModel.isLoading {

                        ProgressView()

                    } else if let error = viewModel.errorMessage {

                        VStack(spacing: 16) {

                            Image(systemName: "wifi.exclamationmark")
                                .font(.largeTitle)

                            Text(error)
                            
                            Button("Повторить") {
                                Task {await viewModel.loadEvents()}
                            }

                        }

                    } else {

                        ForEach(filteredEvents) { event in

                            NavigationLink {

                                EventDetailView(event: event)

                            } label: {

                                EventCard(event: event)

                            }
                            .buttonStyle(.plain)
                            .task {
                                if searchText.isEmpty{
                                    await viewModel.loadMoreIfNeeded(currentItem: event)
                                }
                            }

                        }
                        if viewModel.isLoadingMore {
                            ProgressView()
                                .padding()
                        }

                    }

                }
                .padding()
            }
            .searchable(text: $searchText, prompt: "Поиск событий")
            .navigationTitle("Мероприятия")
            .task {
                await viewModel.loadEvents()
            }
        }
    }

#Preview {
    NavigationStack {
        EventsView()
            .environment(EventsViewModel())
    }
}
