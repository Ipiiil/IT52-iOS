//
//  EventService.swift
//  IT52-iOS
//
//  Created by Полина Терехина on 08.07.2026.
//
import Foundation

final class EventService {
    
    private let api = APIAPIClient()
    
    func loadEvent() async throws -> [EventData]{
        
        let response = try await api.fetchEvents()
         
        return response.data
    }
}
