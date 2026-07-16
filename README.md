# IT52-iOS

Мобильное приложение для сообщества **IT52**, разработанное в рамках производственной практики.

Приложение предоставляет удобный доступ к мероприятиям сообщества, позволяет просматривать информацию о событиях, следить за своим календарем мероприятий и работать с личным профилем.

![Swift](https://img.shields.io/badge/Swift-6-orange)
![iOS](https://img.shields.io/badge/iOS-17+-blue)
![SwiftUI](https://img.shields.io/badge/SwiftUI-MVVM-green)

---


## Скриншоты

<p align="center">
  <img src="https://github.com/Ipiiil/IT52-iOS/blob/master/screenshots/home.PNG?raw=true" width="200" alt="Главная" style="margin: 0 10px;" >
  <img src="https://github.com/Ipiiil/IT52-iOS/blob/master/screenshots/planner.PNG?raw=true" width="200" alt="Планы" style="margin: 0 10px;">
 <img src="https://github.com/Ipiiil/IT52-iOS/blob/master/screenshots/profile.PNG?raw=true" width="200" alt="События" style="margin: 0 10px;">
 <img src="https://github.com/Ipiiil/IT52-iOS/blob/master/screenshots/events.PNG?raw=true" width="200" alt="Профиль" style="margin: 0 10px;">
</p>

---

## Установка и запуск
**1. Клонируйте репозиторий**
``` bash
git clone https://github.com/Ipiiil/IT52-iOS.git
cd IT52-iOS
```

**2. Откройте проект в Xcode**
```bash
open IT52-iOS.xcodeproj
```

**3. Включите режим разработчика на iPhone**

Настройки -> Конфиденциальность и безопасность -> Режим разработчика -> Вкл

**4. Настройте подпись в Xcode**
 + Перейдите во вкладку Signing & Capabilities
 + Выберите свою команду разработчика. Подойдет бесплатный Apple ID

**5. Подключите iPhone и запустите**
 + Подключите iPhone к mac через USB
 + В Xcode выберите ваш реальный iPhone в верхней панели
 + Нажмите Play или Cmd + R

**6. Доверьте разработчика на iPhone**

При первом запуске появится предупреждение. Перейдите в: 

Настройки -> Основные -> VPN и управление устройством -> Доверять разработчику

После этого приложение запустится

---
## Скачать готовую сборку

Готовый IPA-файл для установки на iPhone доступен в разделе [Releases](https://github.com/Ipiiil/IT52-iOS/releases).

**Установка:**
1. Скачайте `IT52-iOS.ipa` из последнего релиза
2. Установите через:
   - **AltStore** — [инструкция](https://altstore.io)
   - **SideStore** — [инструкция](https://sidestore.io)
   - **Xcode** → Window → Devices and Simulators → Add

Приложение не подписано, поэтому требует sideloading-инструментов для установки.

---

## Как внести вклад
Преветствуются любые Pull Requests и Issues!

 + Форкните репозиторий
 + Создайте ветку для вашей фичи
   ```bash
   git checkout -b feature/AmazingFeature
   ```
 + Зафиксируйте изменения
   ``` bash
   git commit -m "Add some AmazingFeature"
   ```
 + Запушьте ветку
   ``` bash
   git push origin feature/AmazingFeature
   ```
 + Откройте Pull Request

---

## Благодарности
 + Сообществу **it52** за открытый API и вдохновение
 + Руководителю практики **Позументову Игорю Игоревичу** за предоставленную возможность
