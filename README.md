# Mobilki - Projekt Studia

Aplikacja mobilna stworzona w ramach projektu studenckiego wykorzystująca Flutter i Firebase.

## Technologie

- Flutter 3.38.2
- Firebase (Authentication, Firestore)
- Dart 3.10.0

## Konfiguracja

### Wymagania
- Flutter SDK
- Firebase CLI
- Android Studio / Xcode (dla rozwoju mobilnego)

### Instalacja

1. Sklonuj repozytorium
2. Zainstaluj zależności:
   ```bash
   flutter pub get
   ```

3. Skonfiguruj Firebase:
   - Utwórz projekt w Firebase Console
   - Uruchom `flutterfire configure` i postępuj zgodnie z instrukcjami
   - Zastąp zawartość `lib/firebase_options.dart` wygenerowaną konfiguracją

### Uruchomienie

```bash
flutter run
```

## Struktura projektu

```
lib/
  ├── main.dart           # Punkt wejścia aplikacji
  └── firebase_options.dart   # Konfiguracja Firebase
```

## Autor

Projekt studencki - 2025
