//
//  EventMapper.swift
//  IT52-iOS
//
//  Created by Полина Терехина on 08.07.2026.
//

import Foundation

struct EventMapper {
    
    static func map(_ data: EventData, organizersByID: [String: IncludedUser]) -> Event{
        
        let organizerName: String
                if let organizerID = data.relationships?.organizer?.data?.id,
                   let organizer = organizersByID[organizerID] {
                    organizerName = "\(organizer.attributes.firstName) \(organizer.attributes.lastName)"
                } else {
                    organizerName = ""
                }
        
        return Event(
            id: Int(data.id) ?? 0,
            title: data.attributes.title,
            description: data.attributes.description,
            date: data.attributes.startedAt,
            location: data.attributes.place ?? "Место уточняется",
            organized: organizerName,
            category: data.attributes.tagList.first ?? "Без категории",
            imageURL: data.attributes.titleImage?.url,
            isFavorite: false,
            isRegistered: false
        )
    }
}
