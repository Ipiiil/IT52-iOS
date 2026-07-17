//
//  CalendarService.swift
//  IT52-iOS
//
//  Created by Полина Терехина on 17.07.2026.
//

//
//  CalendarService.swift
//  IT52-iOS
//
//  Created by Полина Терехина on 17.07.2026.
//

import EventKit
import Foundation
import UIKit

@MainActor
final class CalendarService {
    
    static let shared = CalendarService()
    private let eventStore = EKEventStore()
    
    private init() {}
    //запрашиваем доступ
    func requestAccess() async -> Bool {
        do {
            let granted = try await eventStore.requestFullAccessToEvents()
            print("Доступ к календарю: \(granted ? "разрешён" : "запрещён")")
            return granted
        } catch {
            print("Ошибка запроса доступа к календарю: \(error.localizedDescription)")
            return false
        }
    }

    
    //сохраняем меро в календарь
    func addEventToCalendar(from appEvent: Event) async throws {
        let hasAccess = await requestAccess()
        guard hasAccess else {
            throw CalendarError.accessDenied
        }
        
        let event = EKEvent(eventStore: eventStore)
        event.title = appEvent.title
        event.startDate = appEvent.date
        event.endDate = appEvent.date.addingTimeInterval(7200) // 2 часа
        event.location = appEvent.location
        event.notes = appEvent.description
        event.calendar = eventStore.defaultCalendarForNewEvents
        
        // апоминание за 2 час до события
        let alarm = EKAlarm(relativeOffset: -7200) //
        event.alarms = [alarm]
        
        try eventStore.save(event, span: .thisEvent)
        print("Событие сохранено в календарь: \(appEvent.title)")
    }
}

enum CalendarError: LocalizedError {
    case accessDenied
    case saveFailed
    case eventInPast
    
    var errorDescription: String? {
        switch self {
        case .accessDenied:
            return "Нет доступа к календарю. Разрешите доступ в настройках."
        case .saveFailed:
            return "Не удалось сохранить событие. Попробуйте позже."
        case .eventInPast:
            return "Нельзя добавить событие, которое уже прошло."
        }
    }
}
