//
//  EventDetailView.swift
//  IT52-iOS
//
//  Created by Полина Терехина on 07.07.2026.
//
import SwiftUI
import EventKit

struct EventDetailView: View{
    
    let event: Event
    
    @Environment(AttendanceStore.self) private var attendanceStore
    @Environment(AuthViewModel.self) private var authViewModel
    
    var body: some View {
        
        ScrollView {
            
            VStack(alignment: .leading, spacing: AppTheme.largeSpacing) {
                
                eventImage
                    .frame(maxWidth: .infinity)
                    .frame(height: 220)
                    .clipShape(
                        RoundedRectangle(
                            cornerRadius: AppTheme.cornerRadius
                        )
                    )
                
                
                VStack(alignment: .leading, spacing: AppTheme.mediumSpacing) {
                    
                    Text(event.title)
                        .font(AppFonts.largeTitle)
                    
                    HStack{
                        
                        Image(systemName: "calendar")
                        
                        Text(DateFormatter.ruLong.string(from: event.date))
                    }
                    
                    HStack{
                        
                        Image(systemName: "mappin.and.ellipse")
                        if let url = makeMapsURL(for: event.location) {
                            Link(destination: url) {
                                Text(event.location)
                                    .foregroundStyle(AppColors.accent)
                                    .underline()
                            }
                            .buttonStyle(.plain)
                        } else {
                            Text(event.location)
                        }
                        
                    }
                    
                    HStack{
                        
                        Image(systemName: "person.circle")
                        
                        Text(event.organized)
                    }
                    
                    Text(event.description)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .lineLimit(nil)
                    
                }
                
                if authViewModel.isAuthenticated {
                    Button {
                        attendanceStore.toggleAttendance(for: event)
                    } label: {
                        Label (
                            attendanceStore.isAttending(event) ? "Иду" : "Отметить, что иду",
                            systemImage: attendanceStore.isAttending(event) ? "checkmark.circle.fill" : "circle"
                        )
                        .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(attendanceStore.isAttending(event) ? .green : AppColors.accent)
                    
                    if attendanceStore.isAttending(event) {
                                                Button {
                                                    Task {
                                                        await saveEventToCalendar()
                                                    }
                                                } label: {
                                                    Label("Сохранить в календарь", systemImage: "calendar.badge.plus")
                                                        .frame(maxWidth: .infinity)
                                                }
                                                .buttonStyle(.bordered)
                                                .tint(AppColors.accent)
                                            }
                    
                } else {
                    Text("Войдите, чтобы отмечать события")
                        .font(AppFonts.caption)
                        .foregroundStyle(AppColors.textSecondary)
                }
                /*Button{
                } label: {
                    
                    Text("Записаться")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)*/
                
            }
            .frame(maxWidth: UIScreen.main.bounds.width)
            .padding()
        }
        .navigationTitle("События")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    @ViewBuilder
    private var eventImage: some View {

        if let imageURL = event.imageURL,
           let url = URL(string: imageURL) {

            AsyncImage(url: url) { phase in
                
                switch phase {

                case .success(let image):

                    image
                        .resizable()
                        .scaledToFill()
                        .frame(
                            width: UIScreen.main.bounds.width - 32,
                            height: 220
                        )
                        .clipped()

                case .failure:

                    placeholderImage

                case .empty:

                    ZStack {
                        RoundedRectangle(cornerRadius: AppTheme.cornerRadius)
                            .fill(AppColors.cardBackground)

                        ProgressView()
                    }
                    .frame(height: 220)

                @unknown default:

                    placeholderImage
                }
            }

        } else {
            placeholderImage
        }
    }

        private var placeholderImage: some View {
            RoundedRectangle(cornerRadius: AppTheme.cornerRadius)
                .fill(AppColors.cardBackground)
                .overlay {
                    Image(systemName: "photo")
                        .font(.largeTitle)
                }
        }
    
    // Calendar
        
        private func saveEventToCalendar() async {
            do {
                try await CalendarService.shared.addEventToCalendar(from: event)
                 showAlert(title: "Готово!", message: "Мероприятие добавлено в ваш календарь ")
            } catch CalendarError.accessDenied {
                 showAlert(
                    title: "Нет доступа",
                    message: "Разрешите доступ к календарю в настройках iPhone."
                )
            } catch {
                showAlert(
                    title: "Ошибка",
                    message: "Не удалось сохранить событие: \(error.localizedDescription)"
                )
            }
        }
    
    @MainActor
        private func showAlert(title: String, message: String) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let rootVC = windowScene.windows.first?.rootViewController {
                rootVC.present(alert, animated: true)
            }
        }
    
    
}

extension DateFormatter {
    static let ruShort: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
    
    static let ruLong: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateStyle = .full
        formatter.timeStyle = .short
        return formatter
    }()
}
    
    //MARK: Maps Helper
    
    private func makeMapsURL(for address: String) -> URL? {
        let encodedAddress = address.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? address
        
        //яндекс карты
        let yandexMapsURL = URL(string: "yandexmaps://maps.yandex.ru/?text=\(encodedAddress)")
            if let yandexMapsURL = yandexMapsURL, UIApplication.shared.canOpenURL(yandexMapsURL) {
                return yandexMapsURL
            }
        
        //гугл мапс
        let googleMapsURL = URL(string: "comgooglemaps://?q=\(encodedAddress)")
            if let googleMapsURL = googleMapsURL, UIApplication.shared.canOpenURL(googleMapsURL) {
                return googleMapsURL
            }
        
        //яблочные карты
        return URL(string: "https://maps.apple.com/?q=\(encodedAddress)")
}


/*#Preview {
    NavigationStack {
        EventDetailView(event: MockData.events[0])
            .environment(AttendanceStore())
            .environment(AppState())
        
    }
}
*/
