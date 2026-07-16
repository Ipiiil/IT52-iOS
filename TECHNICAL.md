## 1. Общее описание

**IT52-iOS** — нативное приложение для платформы iOS, разработанное на Swift с использованием фреймворка SwiftUI. Приложение является клиентом для открытого ИТ-сообщества it52 и предоставляет доступ к афише мероприятий, личному кабинету и инструментам планирования.

---

## 2. Архитектура приложения

### 2.1. Паттерн MVVM

Приложение построено на архитектурном паттерне **MVVM** (Model-View-ViewModel):

| Слой | Компоненты | Назначение |
|------|------------|------------|
| **Model** | `Event`, `UserProfile`, `EventResponse`, `User` | Структуры данных и модели для парсинга ответов сервера |
| **View** | Все `*View.swift` файлы | Отображение интерфейса и обработка действий пользователя |
| **ViewModel** | `EventsViewModel`, `AuthViewModel`, `AppState` | Логика приложения, управление состоянием, связь между Model и View |

### 2.2. Управление состоянием

Для управления состоянием используется механизм SwiftUI:
- `@Observable` — отслеживание изменений в моделях
- `@Environment` — внедрение общих объектов (ViewModels) во все экраны приложения
- **Единый источник истины** — все вью используют общие экземпляры ViewModels, что исключает дублирование данных и запросов

### 2.3. Навигация

Приложение использует **TabView** с четырьмя основными экранами:

| Вкладка | Экран | Назначение |
|---------|-------|------------|
| Главная | `HomeView` | Ближайшие мероприятия, информация о сообществе |
| Планы | `PlannerView` | Календарь с отмеченными мероприятиями |
| События | `EventsView` | Полная афиша с поиском и фильтрацией |
| Профиль | `ProfileView` | Личный кабинет (вход/регистрация/редактирование) |

Навигация внутри вкладок реализована через `NavigationStack`.

---

## 3. Сетевой слой

### 3.1. Клиент-серверное взаимодействие

#### API Эндпоинты

| Эндпоинт | Метод | Назначение |
|----------|-------|------------|
| `/api/v2/events` | GET | Получение списка мероприятий (пагинация) |
| `/login` | POST | Авторизация пользователя |
| `/signup` | POST | Регистрация пользователя |
| `/my/profile/edit` | GET | Получение данных профиля |
| `/my/profile` | POST | Обновление профиля |

#### Форматы запросов

| Формат | Использование |
|--------|---------------|
| `application/json` | Получение списка мероприятий (JSON:API) |
| `application/x-www-form-urlencoded` | Авторизация и регистрация |
| `multipart/form-data` | Обновление профиля (с загрузкой изображения) |

### 3.2. APIClient

Базовый клиент для работы с API.

```swift
final class APIClient {
    private let baseURL = URL(string: "https://www.it52.info/api/v2")!
    
    func fetchEvents(page: Int = 1) async throws -> EventResponse
}
```

**Особенности:**
- Использует `URLSession` с поддержкой `async/await`
- Кастомная стратегия декодирования дат (ISO8601 с миллисекундами)
- Обработка формата JSON:API

### 3.3. EventService

Сервис для работы с мероприятиями.

```swift
final class EventService {
    func loadEvents(page: Int) async throws -> (events: [Event], totalPages: Int)
}
```

**Особенности:**
- Маппинг данных из формата JSON:API во внутренние модели
- Пагинация (по 10 записей на страницу)
- Денормализация данных организаторов через словарь для быстрого доступа

### 3.4. AuthService

Сервис для авторизации и регистрации.

```swift
final class AuthService {
    func login(email: String, password: String) async throws -> User
    func register(name: String, email: String, password: String) async throws -> User
    func logout()
}
```

**Особенности:**
- **Reverse Engineering** — сайт it52.info не имеет официального JSON API для авторизации
- Сервис эмулирует поведение браузера при отправке HTML-форм
- Использует библиотеку Devise (Ruby on Rails) с защитой CSRF
- Получение CSRF-токена через парсинг HTML-страниц
- Отправка данных в формате `application/x-www-form-urlencoded`

### 3.5. ProfileService

Сервис для работы с профилем пользователя.

```swift
final class ProfileService {
    func fetchProfile() async throws -> UserProfile
    func updateProfile(_ profile: UserProfile, avatarImageData: Data?) async throws
}
```

**Особенности:**
- Чтение данных профиля через парсинг HTML-страницы `/my/profile/edit`
- Отправка изменений через `multipart/form-data` (поддержка загрузки изображений)
- Двусторонняя синхронизация данных с сайтом

---

## 4. Потоки данных

### 4.1. Загрузка афиши мероприятий

```
Пользователь открывает экран "События"
    ↓
EventsView загружается → вызывает EventsViewModel.loadEvents()
    ↓
ViewModel → EventService.loadEvents(page:) → APIClient.fetchEvents(page:)
    ↓
APIClient → URLSession → GET https://it52.info/api/v2/events?page=1
    ↓
Сервер возвращает JSON:API → JSONDecoder парсит → [Event]
    ↓
ViewModel обновляет @Observable свойство events
    ↓
EventsView автоматически перерисовывается с новыми данными
```

### 4.2. Авторизация

```
Пользователь вводит email и пароль → нажимает "Войти"
    ↓
LoginView → AuthViewModel.login(email:password:)
    ↓
AuthService.login(email:password:)
    ↓
1. GET /login → парсинг HTML → извлечение CSRF-токена
2. POST /login с email, паролем и CSRF-токеном
    ↓
Сервер возвращает 302 → в cookie записывается сессия
    ↓
Пользователь сохраняется в UserDefaults → isAuthenticated = true
```

### 4.3. Редактирование профиля

```
Пользователь изменяет данные → нажимает "Сохранить"
    ↓
UserProfileView → ProfileService.updateProfile()
    ↓
1. GET /my/profile/edit → извлечение CSRF-токена
2. Формирование multipart/form-data (если есть фото)
3. POST /my/profile с данными и токеном
    ↓
Сервер возвращает 302 (успех) или 200 (ошибка валидации)
    ↓
При успехе → повторная загрузка профиля → обновление UI
```

---

## 5. Вспомогательные утилиты

### 5.1. WebFormHelper

Утилита для парсинга HTML-форм и взаимодействия с веб-интерфейсом сайта.

```swift
enum WebFormHelper {
    static func fetchCSRFToken(from url: URL) async throws -> String
    static func extractCSRFToken(from html: Data) throws -> String
    static func formEncode(_ params: [String: String]) -> Data
    static func multipartBody(...) -> Data
    static func extractInputValue(name: String, from html: String) -> String?
    static func extractTextareaValue(name: String, from html: String) -> String?
    static func extractCheckboxChecked(name: String, from html: String) -> Bool
    static func extractSelectedCategoryIDs(from html: String) -> [Int]
    static func extractAvatarURL(from html: String) -> String?
}
```

**Назначение:**
- Извлечение CSRF-токенов из HTML-разметки
- Формирование запросов в форматах `application/x-www-form-urlencoded` и `multipart/form-data`
- Парсинг полей форм для чтения текущих значений профиля

### 5.2. LossyDecodableArray

Отказоустойчивый массив для парсинга JSON:API.

```swift
struct LossyDecodableArray<Element: Decodable>: Decodable {
    private(set) var elements: [Element] = []
}
```

**Назначение:**
- Если один элемент в массиве не может быть распарсен, остальные всё равно загружаются
- Предотвращает падение всего приложения из-за одного "битого" мероприятия

---

## 6. Интеграция с UIKit

### 6.1. EventsPlannerView

Календарь-планировщик, реализованный через интеграцию UIKit в SwiftUI.

```swift
struct EventsPlannerView: UIViewControllerRepresentable {
    @Binding var selectedDate: Date
    let datesWithEvents: Set<String>
}
```

**Особенности:**
- Использование `UICalendarView` из UIKit
- Обёртка через протокол `UIViewControllerRepresentable`
- Визуальная индексация дат (точки под датами, на которые запланированы мероприятия)
- Реализация делегатов `UICalendarViewDelegate` и `UICalendarSelectionSingleDateDelegate`

---

## 7. Хранение данных

| Механизм | Данные |
|----------|--------|
| **UserDefaults** | Отметки "Иду" (`attendingEventIDs`), текущий пользователь (`currentUser`) |
| **HTTPCookieStorage** | Сессионные cookie авторизации |
| **URLCache** | Кэширование сетевых ответов и изображений |

---

## 8. Обработка ошибок

### 8.1. Сетевые ошибки

| Тип ошибки | Механизм | Отображение |
|------------|----------|-------------|
| Ошибка сети (No Internet) | URLSession throws | Alert с предложением повторить |
| Ошибка сервера (500) | URLError.badServerResponse | Текст "Что-то пошло не так" |
| Ошибка авторизации | AuthError.invalidCredentials | "Неверный email или пароль" |
| Ошибка валидации формы | HTTP 200 с flash-сообщением | Парсинг ошибок из HTML |

### 8.2. Найденные и исправленные ошибки

| Ошибка | Причина | Решение |
|--------|---------|---------|
| Неправильное кодирование CSRF-токена | Спецсимволы не экранировались | Добавлено процентное кодирование (Percent-encoding) |
| Аварийное завершение при загрузке изображений | Нехватка памяти | Добавлен URLCache и ограничение объема кэша |
| Ошибка трактовки HTTP 200 как успеха | Сервер возвращает 200 при ошибке валидации | Добавлен парсинг flash-сообщений из HTML |

---

## 9. Структура проекта

```
IT52-iOS/
├── App/                              # Точка входа
│   └── IT52_iOSApp.swift
├── Models/                           # Модели данных
│   ├── Event.swift
│   ├── EventResponse.swift
│   ├── UserProfile.swift
│   └── Interests.swift
├── ViewModels/                       # Логика и состояние
│   ├── AuthViewModel.swift
│   ├── EventsViewModel.swift
│   ├── AttendanceStore.swift
│   └── AppState.swift
├── Views/                            # UI Компоненты
│   ├── TabBarView.swift
│   ├── HomeView.swift
│   ├── EventsView.swift
│   ├── PlannerView.swift
│   ├── ProfileView.swift
│   ├── LoginView.swift
│   ├── RegisterView.swift
│   └── Components/
│       ├── EventCard.swift
│       ├── SearchBar.swift
│       ├── InterestsSection.swift
│       └── ...
├── Services/                         # Сетевые сервисы
│   ├── APIClient.swift
│   ├── EventService.swift
│   ├── AuthService.swift
│   └── ProfileService.swift
├── Helpers/                          # Утилиты
│   ├── WebFormHelper.swift
│   ├── AppColors.swift
│   ├── AppFonts.swift
│   └── NetworkSession.swift
└── Resources/
    └── Assets.xcassets
```

---

## 10. Требования и зависимости

### 10.1. Минимальные требования

| Компонент | Версия |
|-----------|--------|
| iOS | 17.0+ |
| Xcode | 15.0+ |
| Swift | 5.9+ |
| macOS | Ventura+ |

### 10.2. Зависимости

**Внешние зависимости отсутствуют** — проект использует только стандартные фреймворки Apple:
- SwiftUI
- UIKit
- Foundation
- PhotosUI

---

## 11. Тестирование и отладка

### Инструменты отладки

- **curl** — ручная проверка API на всех этапах
- **Network Inspector в Xcode** — анализ сетевых запросов
- **os.log** — логирование для диагностики

---

## 12. Планы по развитию

- [ ] Добавление пуш-уведомлений о новых мероприятиях
- [ ] Добавление знака уведомления на вкладке "Планы" для ближайших событий
- [ ] Импортирование планов в календарь iPhone
- [ ] Кликабельные ссылки на страницах мероприятий
- [ ] Кликабельная геолокация
- [ ] Widget для отображения ближайших событий на главном экране
- [ ] Тёмная тема

---

## 13. Сборка и запуск

Подробная инструкция приведена в файле [README.md](README.md).

**Кратко:**
1. Клонировать репозиторий
2. Открыть в Xcode
3. Настроить команду разработчика (Signing)
4. Запустить на симуляторе или реальном устройстве

---

## 14. Контакты

По вопросам, связанным с проектом:
- GitHub: [Ipiiii](https://github.com/Ipiiil)
- Проект: [IT52-iOS](https://github.com/Ipiiil/IT52-iOS)
