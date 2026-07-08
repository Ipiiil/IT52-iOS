//
//  MockData.swift
//  IT52-iOS
//
//  Created by Полина Терехина on 06.07.2026.
//

import Foundation

enum MockData {
    
    static let events: [Event] = [
        
        Event(
            id: 1,
            title: "Летняя IT-школа группы компаний <<ТЕКОМ>>",
            description: "Приглашаем студентов профильных ВУЗов для прохождения летней практики",
            date: .now,
            location: "г. Н.Новгород, ул. Карла Маркса, д. 44Б",
            organized: "",
            category: "courses",
            imageURL: nil,
            isFavorite: true,
            isRegistered: true
        ),
        
        Event (
            id: 2,
            title: "Python 10!",
            description: "Ежеквартальный митап",
            date: .now,
            location: "г. Н.Новгород, ул. Алексеевская, д 6/16",
            organized: "Анастасия Олеск",
            category: "meetup",
            imageURL: nil,
            isFavorite: false,
            isRegistered: false
        ),
    ]
}
