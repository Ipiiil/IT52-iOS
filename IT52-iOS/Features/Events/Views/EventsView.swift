//
//  EventsView.swift
//  IT52-iOS
//
//  Created by Полина Терехина on 06.07.2026.
//

import SwiftUI

struct EventsView: View {
    
    @Environment(AppState.self)
    private var appState
    
    @State private var viewModel = EventsViewModel()
    @State private var searchText = ""
    
    
    private var filteredEvents: [Event] {

        var events = viewModel.events

        // Фильтрация по интересам
        if viewModel.selectedFilter == .interests,
           !appState.selectedInterests.isEmpty {

            events = events.filter { event in
                !Set(event.tagList).isDisjoint(with: appState.selectedInterests)
            }

        }

        // Поиск
        if !searchText.isEmpty {

            events = events.filter {
                $0.title.localizedCaseInsensitiveContains(searchText)
            }

        }

        return events
    }
    
    var body: some View {
            
            ScrollView {
                
                Picker("Фильтр", selection: $viewModel.selectedFilter) {
                    
                    Text("Все")
                        .tag(EventFilter.all)
                    
                    Text("Мои интересы")
                        .tag(EventFilter.interests)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                .padding(.top)
                
                
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

                        ForEach(filteredEvents){ event in

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
