//
//  EventService.swift
//  IT52-iOS
//
//  Created by Полина Терехина on 08.07.2026.
//
import Foundation

final class EventService {
    
    private let api = APIClient()
    
    func loadEvents(page: Int) async throws -> (events: [Event], totalPages: Int) {
        
        let response = try await api.fetchEvents(page: page)
         
        let organizedByID = Dictionary(
            uniqueKeysWithValues: (response.included?.elements ?? []).map {($0.id, $0)}
        )
        
        let events = response.data.map {
            
            EventMapper.map($0, organizersByID: organizedByID)
        }
        
        return (events, response.meta?.totalPages ?? page)
    }
}
