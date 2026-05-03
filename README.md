# Workout Tracker 2026

> Мобильное приложение для отслеживания тренировок, построенное на Flutter с использованием чистой архитектуры.

---

## Описание

**Workout Tracker 2026** — кроссплатформенное Flutter-приложение для ведения дневника тренировок. Пользователь может создавать собственные упражнения, добавлять тренировки с подходами и повторениями, просматривать историю и анализировать прогресс с помощью интерактивных графиков.

---

## Скриншоты

> *<img width="175" height="880" alt="WhatsApp Image 2026-05-03 at 19 40 51" src="https://github.com/user-attachments/assets/3b2718b3-d7b4-48fe-918e-a8bd04a80a49" />
<img width="575" height="1280" alt="WhatsApp Image 2026-05-03 at 19 40 51 (1)" src="https://github.com/user-attachments/assets/6b56df0b-c8f9-4f8a-b54b-635b30b18360" />
<img width="575" height="1280" alt="WhatsApp Image 2026-05-03 at 19 40 51 (2)" src="https://github.com/user-attachments/assets/d2bf5d93-6c2d-44d9-886a-2e71a5913496" />
<img width="575" height="1280" alt="WhatsApp Image 2026-05-03 at 19 40 51 (3)" src="https://github.com/user-attachments/assets/495b72ed-1a45-4278-9e71-5d2eb3172fde" />
<img width="575" height="1280" alt="WhatsApp Image 2026-05-03 at 19 40 51 (4)" src="https://github.com/user-attachments/assets/b06dbd3b-acd5-4d3b-b2d7-5d1f24c6b703" />
<img width="575" height="1280" alt="WhatsApp Image 2026-05-03 at 19 40 51 (5)" src="https://github.com/user-attachments/assets/7a413e12-707a-453b-b68a-8fd108a15e63" />*

---

## Функциональность

| Модуль | Возможности |
|---|---|
| **Аутентификация** | Регистрация и вход с локальным хранением учётных данных через `flutter_secure_storage` |
| **Упражнения** | Создание упражнений с выбором группы мышц (Грудь, Спина, Ноги, Плечи, Руки, Кор, Кардио) |
| **Тренировки** | Создание тренировок: добавление упражнений, подходов (вес × повторения) |
| **История** | Просмотр прошлых тренировок с детализацией каждого упражнения и подхода |
| **Дашборд** | Сводная статистика и недельный график объёма нагрузки (кг × повт.) |
| **Статистика** | Детальные графики прогресса по объёму и максимальному весу; фильтр по упражнению и группе мышц |
| **Тема** | Переключение между светлой и тёмной темой (Material 3, Indigo palette) |

---

## Архитектура

Проект следует принципам **Clean Architecture** с разделением на три слоя:

```
lib/
├── core/               # Константы, роутер (GoRouter), тема, утилиты
├── data/               # Модели Hive, локальные источники данных, репозитории
├── domain/             # Сущности (Entity), интерфейсы репозиториев, Use Cases
└── presentation/       # Экраны, виджеты, Riverpod-провайдеры
    ├── screens/
    │   ├── auth/       # LoginScreen, RegisterScreen
    │   ├── dashboard/  # DashboardScreen (статистика + график)
    │   ├── exercises/  # ExercisesScreen, AddExerciseScreen
    │   ├── workout/    # CreateWorkoutScreen, WorkoutDetailScreen
    │   ├── history/    # HistoryScreen
    │   └── stats/      # StatsScreen (прогресс)
    ├── providers/      # Riverpod-провайдеры (workout, exercise, theme)
    └── widgets/        # GlassCard, GradientScaffold, MuscleGroupChip...
```

### Используемые технологии

| Пакет | Версия | Назначение |
|---|---|---|
| `flutter_riverpod` | ^2.6.1 | Управление состоянием |
| `go_router` | ^14.2.7 | Декларативная навигация |
| `hive_flutter` | ^1.1.0 | Локальная NoSQL-база данных |
| `fl_chart` | ^0.69.0 | Интерактивные графики |
| `flutter_secure_storage` | ^9.0.0 | Безопасное хранение токенов/паролей |
| `uuid` | ^4.4.2 | Генерация уникальных идентификаторов |
| `intl` | ^0.19.0 | Форматирование дат |

---

## Требования

- **Flutter** ≥ 3.24 (Dart SDK ^3.5.0)
- **Android** API 21+ / **iOS** 12+

---

## Установка и запуск

```bash
# 1. Клонировать репозиторий
git clone https://github.com/QasT-X09/Workout-tracker.git
cd Workout-tracker

# 2. Установить зависимости
flutter pub get

# 3. Сгенерировать Hive-адаптеры (если нужно пересобрать)
dart run build_runner build --delete-conflicting-outputs

# 4. Запустить приложение
flutter run
```

---

## Сборка APK

```bash
flutter build apk --release
# Готовый APK: build/app/outputs/flutter-apk/app-release.apk
```

---

## Структура данных

```
Workout
  └── id: String (UUID)
  └── date: DateTime
  └── exercises: List<WorkoutExercise>
         └── exercise: Exercise (id, name, muscleGroup)
         └── sets: List<SetData>
                  └── reps: int
                  └── weight: double
```

---

## Автор

**QasT-X09** — [GitHub](https://github.com/QasT-X09)


## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
