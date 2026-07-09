//
//  AttendanceStore.swift
//  IT52-iOS
//
//  Created by Полина Терехина on 09.07.2026.
//
import Foundation
import Observation

@MainActor
@Observable
final class AttendanceStore {

    private(set) var attendingEventIDs: Set<Int> = []

    private let storageKey = "attendingEventIDs"

    init() {
        let saved = UserDefaults.standard.array(forKey: storageKey) as? [Int] ?? []
        attendingEventIDs = Set(saved)
    }

    func isAttending(_ event: Event) -> Bool {
        attendingEventIDs.contains(event.id)
    }

    func toggleAttendance(for event: Event) {
        if attendingEventIDs.contains(event.id) {
            attendingEventIDs.remove(event.id)
        } else {
            attendingEventIDs.insert(event.id)
        }
        UserDefaults.standard.set(Array(attendingEventIDs), forKey: storageKey)
    }
}
