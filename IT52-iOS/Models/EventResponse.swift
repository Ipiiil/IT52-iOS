//
//  EventResponse.swift
//  IT52-iOS
//
//  Created by Полина Терехина on 08.07.2026.
//

import Foundation

struct EventResponse: Decodable {
    
    let data: [EventData]
    
}

struct EventData: Decodable {
    
    let id: String
    
    let attributes: EventAttributes
    
}

struct EventAttributes: Decodable {
    
    let title: String
    
    let description: String
    
    let startedAt: Date
    
    let place: String?
    
    let titleImage: TitleImage?
    
    let tagList: [String]
    
    enum CodingKeys: String, CodingKey {
        
        case title
        case description
        case startedAt = "startedAt"
        case place
        case titleImage = "titleImage"
        case tagList = "tagList"
        
    }
}

struct TitleImage: Decodable {
    
    let url: String?
}
