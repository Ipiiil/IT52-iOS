//
//  EventResponse.swift
//  IT52-iOS
//
//  Created by Полина Терехина on 08.07.2026.
//

import Foundation

struct EventResponse: Decodable {
    
    let data: [EventData]
    
    let included: LossyDecodableArray<IncludedUser>?
    
    let meta: Meta?
    
}

struct Meta: Decodable {
    
    let totalCount: Int
    
    let totalPages: Int

    enum CodingKeys: String, CodingKey {
    
        case totalCount = "total_count"
        
        case totalPages = "total_pages"
    }
}

struct EventData: Decodable {
    
    let id: String
    
    let attributes: EventAttributes
    
    let relationships: EventRelationships?
    
}

struct EventAttributes: Decodable {
    
    let title: String
    
    let description: String
    
    let startedAt: Date
    
    let place: String?
    
    let titleImage: TitleImage?
    
    let tagList: [String]
    let kind: String?
}


struct TitleImage: Decodable {
    
    let url: String?
}

struct EventRelationships: Decodable {
    
    let organizer: OrganizerRelationship?
}

struct OrganizerRelationship: Decodable {
    let data: OrganizerData?
}

struct OrganizerData: Decodable {
    let id: String
}

// Included (users, и в будущем возможно другие типы)

struct IncludedUser: Decodable {
    let id: String
    let type: String
    let attributes: IncludedUserAttributes
}

struct IncludedUserAttributes: Decodable {
    let firstName: String
    let lastName: String
    let nickname: String?
}

//  Отказоустойчивый массив: пропускает элементы, которые не смог распарсить,
// вместо падения декодирования целиком

struct LossyDecodableArray<Element: Decodable>: Decodable {

    private(set) var elements: [Element] = []

    private struct AnyElement: Decodable {
        let value: Element?
        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            value = try? container.decode(Element.self)
        }
    }

    init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        var result: [Element] = []
        while !container.isAtEnd {
            let wrapped = try container.decode(AnyElement.self)
            if let value = wrapped.value {
                result.append(value)
            }
        }
        elements = result
    }
}
