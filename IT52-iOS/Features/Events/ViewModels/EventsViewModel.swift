//
//  EventsViewModel.swift
//  IT52-iOS
//
//  Created by Полина Терехина on 08.07.2026.
//
import Foundation
import Observation

enum EventFilter {
    case all
    case interests
}

@MainActor
@Observable


final class EventsViewModel {
    
    var events: [Event] = []
    var isLoading = false
    var isLoadingMore = false
    var errorMessage: String?
    
    var selectedFilter: EventFilter = .all
    
    private let service = EventService()
    private var currentPage = 1
    private var totalPages = 1
    
    var canLoadMore: Bool {
        
        currentPage < totalPages
    }
    
    func loadEvents() async {
        
        isLoading = true
        errorMessage = nil
        currentPage = 1
        
        do {
            let result = try await service.loadEvents(page: currentPage)
            events = result.events
            totalPages = result.totalPages
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func loadMoreIfNeeded(currentItem event: Event) async {
        
        guard let index = events.firstIndex(where: { $0.id == event.id }) else { return }
        
        // подгружаем следующую страницу, когда пользователь долистал до последних 3 элементов
        let thresholdIndex = events.index(events.endIndex, offsetBy: -3, limitedBy: events.startIndex) ?? events.startIndex
        guard index >= thresholdIndex else { return }
        
        guard canLoadMore, !isLoadingMore else { return }
        
        isLoadingMore = true
        currentPage += 1
        
        do {
            let result = try await service.loadEvents(page: currentPage)
            events.append(contentsOf: result.events)
            totalPages = result.totalPages
        } catch {
            currentPage -= 1
        }
        
        isLoadingMore = false
    }
}
