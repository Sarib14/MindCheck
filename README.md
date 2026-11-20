# MindCheck – Daily Mood Journal & Mental Wellness App

MindCheck is a personal mental wellness application developed using **Flutter and Dart**. It helps users understand their emotional patterns, record daily moods, maintain personal journal entries, and practice simple mindfulness and relaxation exercises.

The application provides a private and user-friendly environment for mood tracking and self-reflection, with locally stored and encrypted mood data.

---

## Project Overview

| Detail | Description |
|---|---|
| Project Name | MindCheck |
| Category | Mental Wellness |
| Framework | Flutter |
| Programming Language | Dart |
| IDE | Visual Studio Code |
| Version | 1.0.0 |


## Key Features

### 1. Daily Mood Check-in
- Record your daily emotional state.
- Select from available moods or choose a custom mood.
- Set mood intensity.
- Add optional personal journal notes.
- Save entries for future reference.

### 2. Mood History and Journal Management
- View previously recorded mood entries.
- Create, edit, and delete journal entries.
- Search and filter mood records.
- Access saved entries whenever needed.

### 3. Secure Local Storage
- Stores mood and journal information locally.
- Uses AES-256-GCM encryption for stored mood data.
- Uses Flutter Secure Storage to protect the encryption key.
- Does not require an online account.

### 4. Light and Dark Themes
- Supports light and dark modes.
- Saves the selected theme preference.
- Provides a consistent visual experience.

### 5. Weekly Mood Summary
- Displays mood activity for the previous seven days.
- Shows the total number of mood entries.
- Identifies the most frequently recorded mood.
- Presents mood activity through a visual chart.
- Provides helpful reminders and empty-state messages.

### 6. Guided Breathing Exercise
- Includes a guided 4–4–6 breathing technique.
- 4 seconds for inhaling.
- 4 seconds for holding the breath.
- 6 seconds for exhaling.
- Provides Start, Pause, and Reset controls.
- Includes an animated breathing circle and completed cycle counter.
- Provides basic wellness tips.

### 7. Monthly Mood Calendar
- Displays recorded moods in a monthly calendar.
- Allows navigation between previous and next months.
- Uses colored indicators to represent moods.
- Allows users to select a date and view its mood details.
- Displays available intensity and journal notes.

### 8. 5–4–3–2–1 Grounding Exercise
- Provides an interactive grounding activity.
- Guides users through five senses:
  - 5 things you can see.
  - 4 things you can feel.
  - 3 things you can hear.
  - 2 things you can smell.
  - 1 thing you can taste.
- Encourages mindfulness and awareness of the present moment.

---

## Technologies and Packages

| Technology | Purpose |
|---|---|
| Flutter | Cross-platform application development |
| Dart | Application programming language |
| Visual Studio Code | Development environment |
| Shared Preferences | Local preference and encrypted-data storage |
| Flutter Secure Storage | Secure encryption-key storage |
| Cryptography | AES-256-GCM encryption |
| Flutter Test | Application testing |

### Main Dependencies

- `shared_preferences`
- `flutter_secure_storage`
- `cryptography`
- `cupertino_icons`

---

## Project Structure

```text
MindCheck/
│
├── android/
│
├── lib/
│   ├── main.dart
│   │
│   ├── models/
│   │
│   ├── providers/
│   │
│   ├── screens/
│   │
│   ├── services/
│   │
│   ├── theme/
│   │
│   └── widgets/
│
├── screenshots/
│
├── test/
│   └── widget_test.dart
│
├── .github/
│   └── workflows/
│
├── pubspec.yaml
├── pubspec.lock
├── analysis_options.yaml
└── README.md
```

---

## Internship Module Development

### Module 1 – Project Setup and UI Development
**Duration:** October 26 – November 01, 2026

- Configured the Flutter development environment.
- Created the MindCheck Flutter project.
- Organized the project structure.
- Designed the application theme.
- Developed the welcome and home screens.
- Established screen navigation.
- Planned the mood and journal data structure.
- Tested the initial application on Android.

### Module 2 – Mood Tracking and Journal Management
**Duration:** November 02 – November 08, 2026

- Implemented daily mood check-ins.
- Added custom mood selection and intensity levels.
- Added optional journal notes.
- Implemented create, view, edit, and delete operations.
- Integrated local data storage.
- Developed mood history with search and filtering.
- Implemented persistent light and dark themes.
- Added input validation and empty-state handling.

### Module 3 – Mood Insights and Wellness Features
**Duration:** November 09 – November 15, 2026

- Developed weekly mood summaries and visual charts.
- Implemented guided 4–4–6 breathing exercises.
- Added breathing animation, countdown, and controls.
- Developed the monthly mood calendar.
- Implemented the interactive 5–4–3–2–1 grounding exercise.
- Improved home-screen navigation and UI consistency.
- Added wellness tips and improved empty states.

### Module 4 – Testing and Documentation
**Duration:** November 16 – November 22, 2026

- Tested application screens and major features.
- Checked mood creation, editing, deletion, and data persistence.
- Reviewed input validation and empty-state handling.
- Tested application layouts and responsiveness.
- Fixed identified bugs and improved application stability.
- Performed Flutter code analysis.
- Executed widget tests.
- Prepared the Flutter Web release build.
- Updated project documentation.

---

## Data Privacy and Security

MindCheck is designed with a privacy-focused local storage approach.

- Mood and journal records are stored locally.
- AES-256-GCM is used to encrypt stored mood data.
- Flutter Secure Storage is used to protect the encryption key.
- No online account is required for the application's local features.
- The application does not require users to upload their personal journal entries to a remote database.

**Note:** Local encryption protects stored data, but users should still keep their devices secure and maintain appropriate backups.

---


### Prerequisites

Install the following before running the project:

- Flutter SDK
- Dart SDK (included with Flutter)
- Visual Studio Code
- Flutter and Dart extensions for VS Code
- Android Studio or an Android device/emulator (for Android testing)

## Testing

The following commands can be used to verify the project.

**Check code quality:**

```bash
flutter analyze
```

**Run automated tests:**

```bash
flutter test
```

The project has been checked using Flutter analysis, widget testing, and a Flutter Web release build during Module 4 preparation.

---

## Screenshots

Application screenshots can be added to the `screenshots/` directory.

They can be viewed directly from the repository to explore the application's interface and features.

---

## Project Objective

The main objective of MindCheck is to provide users with a simple and private way to monitor their emotional well-being. Through daily mood tracking, journaling, mood insights, and mindfulness exercises, the application encourages self-awareness and healthy reflection.

MindCheck is designed as a personal wellness companion and is not a replacement for professional mental health care.

---


**GitHub Repository:**  
https://github.com/Sarib14/MindCheck

---

*MindCheck – Understand your mood. Reflect on your day. Take care of yourself.*