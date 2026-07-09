//
//  EventsPlannerView.swift
//  IT52-iOS
//
//  Created by Полина Терехина on 09.07.2026.
//
import SwiftUI

struct EventsPlannerView: UIViewRepresentable {
    
    @Binding var selectedDate: Date
    let datesWithEvents: Set<String>
    
    static func dayKey(_ date: Date) -> String {
        let comps = Calendar.current.dateComponents([.year, .month, .day], from: date)
        return "\(comps.year ?? 0) -\(comps.month ?? 0) - \(comps.day ?? 0)"
    }
    
    func makeUIView(context: Context) -> UICalendarView {
        let calendarView = UICalendarView()
        calendarView.calendar = Calendar.current
        calendarView.locale = Locale(identifier: "ru_RU")
        calendarView.delegate = context.coordinator
        
        let selection = UICalendarSelectionSingleDate(delegate: context.coordinator)
        selection.setSelected(
            Calendar.current.dateComponents([.year, .month, .day], from: selectedDate),
            animated: false
        )
        calendarView.selectionBehavior = selection
        
        return calendarView
    }
    
    func updateUIView(_ uiView: UICalendarView, context: Context) {
        context.coordinator.parent = self
        
        if let selection = uiView.selectionBehavior as? UICalendarSelectionSingleDate {
            let comps = Calendar.current.dateComponents([.year, .month, .day], from: selectedDate)
            if selection.selectedDate != comps {
                selection.setSelected(comps, animated: true)
            }
        }
        
        let visibleComponents = (0..<400).compactMap { offset -> DateComponents? in
            guard let date = Calendar.current.date(byAdding: .day, value: offset - 200, to: .now) else {return nil}
            return Calendar.current.dateComponents([.year, .month, .day], from: date)
        }
        uiView.reloadDecorations(forDateComponents: visibleComponents, animated: false)
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    final class Coordinator: NSObject, UICalendarViewDelegate, UICalendarSelectionSingleDateDelegate {
        
        var parent: EventsPlannerView
        
        init(parent: EventsPlannerView) {
            self.parent = parent
        }
        
        func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
            guard let dateComponents, let date = Calendar.current.date(from: dateComponents) else { return}
            parent.selectedDate = date
        }
        
        func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
            guard let date = Calendar.current.date(from: dateComponents) else { return nil }
            let key = EventsPlannerView.dayKey(date)
            guard parent.datesWithEvents.contains(key) else { return nil }
            return .default(color: .systemGreen, size: .medium)
        }
    }
}
