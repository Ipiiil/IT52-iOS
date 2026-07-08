//
//  APIClient.swift
//  IT52-iOS
//
//  Created by Полина Терехина on 08.07.2026.
//

import Foundation

final class APIClient {
    
    private let baseURL = URL(string: "https://www.it52.info/api/v2")!
    
    func fetchEvents() async throws -> EventResponse {
        
        let url = baseURL.appending(path: "events")
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse,
              response.statusCode == 200 else {
            
            throw URLError(.badServerResponse)
            
        }
        
        let decoder = JSONDecoder()
        
        let formatter = ISO8601DateFormatter()
        
        formatter.formatOptions = [
            .withInternetDateTime,
            .withFractionalSeconds
        ]
        
        decoder.dateDecodingStrategy = .custom{ decoder in
            
            let container = try decoder.singleValueContainer()
            
            let string = try container.decode(String.self)
            
            guard let date = formatter.date(from: string) else {
                throw DecodingError.dataCorruptedError(
                    in: container,
                    debugDescription: "Неверная дата")
                
            }
            return date
        }
        return try decoder.decode(
            EventResponse.self,
            from: data
        )
    }
}
