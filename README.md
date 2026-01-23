# Mobilki - Repozytorium Książek Cyfrowych

Aplikacja mobilna do zarządzania repozytorium książek w formacie cyfrowym (PDF, EPUB). Projekt studencki wykorzystujący Flutter i Firebase.

## Funkcjonalności

- 📚 Przeglądanie listy książek z metadanymi statycznymi (tytuł, autor)
- 📖 Pobieranie plików książek na urządzenie
- 🏷️ Dynamiczne metadane (dodawanie, usuwanie, podgląd) - np. rodzaj: proza, wiersz
- 🔐 Logowanie użytkowników (Firebase Auth)
- 👤 Dwa poziomy dostępu:
  - **Gość (anonimowy)**: tylko podgląd
  - **Użytkownik (zalogowany)**: zapis, odczyt, usuwanie metadanych

## Technologie

- Flutter 3.38.2
- Dart 3.10.0
- Firebase (Authentication, Firestore, Storage, Cloud Functions)
- Node.js 20

## Konfiguracja

### Wymagania

- Flutter SDK
- Firebase CLI (`npm install -g firebase-tools`)
- FlutterFire CLI (`dart pub global activate flutterfire_cli`)
- Node.js 20+
- Android Studio / Xcode (dla rozwoju mobilnego)

### Instalacja

1. Sklonuj repozytorium:
   ```bash
   git clone https://github.com/Sahyas/mobilki.git
   cd mobilki
   ```

2. Zainstaluj zależności Flutter:
   ```bash
   flutter pub get
   ```

3. Zainstaluj zależności Cloud Functions:
   ```bash
   cd functions
   npm install
   cd ..
   ```

4. Skonfiguruj Firebase:
   - Utwórz projekt w Firebase Console
   - Uruchom `flutterfire configure` i postępuj zgodnie z instrukcjami
   - Zastąp zawartość `lib/firebase_options.dart` wygenerowaną konfiguracją

### Uruchomienie

#### Aplikacja Flutter
```bash
flutter run
```

#### Firebase Emulatory (lokalne testowanie)
```bash
firebase emulators:start --only functions,storage,firestore
```

Emulator UI dostępny pod: http://localhost:4000

#### Upload książek (batch)
Dodaj pliki PDF/EPUB do folderu `resources/books/`, następnie:
```bash
chmod +x upload_books.sh
./upload_books.sh
```

## Struktura projektu

```
lib/
  ├── main.dart                 # Punkt wejścia aplikacji
  ├── firebase_options.dart     # Konfiguracja Firebase
  ├── models/
  │   ├── book.dart             # Model książki
  │   └── dynamic_metadata.dart # Model metadanych dynamicznych
  ├── screens/
  │   ├── home_screen.dart      # Ekran główny (lista książek)
  │   ├── book_detail_screen.dart # Szczegóły książki
  │   ├── book_list_screen.dart # Lista książek
  │   └── login_screen.dart     # Ekran logowania
  └── services/
      ├── auth_service.dart     # Serwis autentykacji
      └── book_service.dart     # Serwis obsługi książek

functions/
  ├── index.js                  # Cloud Functions (trigger na upload)
  └── package.json              # Zależności Node.js

resources/
  └── books/                    # Pliki książek (PDF/EPUB)
```

## Autor

Projekt studencki - 2026
