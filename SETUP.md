# Инструкция по запуску Flutter проекта

## 1. Проверка установки Flutter

Откройте терминал и выполните:
```bash
flutter --version
```

Если Flutter не установлен, скачайте с https://flutter.dev

## 2. Установка зависимостей

```bash
cd bally_flutter
flutter pub get
```

## 3. Запуск приложения

### На эмуляторе:
```bash
flutter run
```

### На физическом устройстве (Android):
1. Включите "Режим разработчика" на телефоне
2. Включите "Отладку по USB"
3. Подключите телефон к ПК
4. Запустите: `flutter run`

## 4. Сборка APK

```bash
flutter build apk --release
```

APK будет в: `build/app/outputs/flutter-apk/app-release.apk`

## 5. Горячая перезагрузка

Во время разработки:
- `r` - горячая перезагрузка
- `R` - горячая перезагрузка с сбросом
- `q` - выход

## Структура проекта

```
bally_flutter/
├── lib/
│   ├── main.dart              # Точка входа
│   ├── models/                # Модели данных
│   │   ├── task.dart
│   │   ├── shop_item.dart
│   │   └── transaction.dart
│   ├── providers/             # Управление состоянием
│   │   └── app_provider.dart
│   ├── screens/               # Экраны
│   │   ├── home_screen.dart
│   │   ├── shop_screen.dart
│   │   └── journal_screen.dart
│   └── widgets/               # Виджеты
│       ├── task_card.dart
│       ├── shop_card.dart
│       └── journal_card.dart
└── pubspec.yaml               # Зависимости
```

## Устранение проблем

### Ошибка "No devices found"
- Android: `flutter devices`
- Проверьте подключение устройства

### Ошибка зависимостей
```bash
flutter clean
flutter pub get
```

### Изменения в pubspec.yaml не применяются
```bash
flutter pub get
```
