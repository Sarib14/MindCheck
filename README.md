# MindCheck – Personal Mental Wellness App

## 1. Project Overview

MindCheck is a Flutter-based mobile application designed to support personal mental wellbeing. it allows users to record users their daily moods, write personal reflections, view mood history, and perform grounding exercises

## 2. Objectives and Completed Work:
Set up the flutter project and development environment.
Organized Dart files into separate folders, including screens, models, services, themes and widgets.
Designed a consistent application theme.
Developed the welcome and Home Screen UI.
Implemented navigation between Sett screens.
Planned mood and journal data fields. 
Built the initial user interface.
Ran and tested the application on an Android device.

## 3. Technologies Used:
Flutter.
Dart.
Visual Studio Code.
Shared Preferences.
Flutter Secure Storage.
Cryptography package

## 4. Additional Features Implemented:
Beyond the basic Module 1 requirements, the following features were developed:
Mood Check-In: Seven mood options.
Mood Intensity: Rating from 1 to 5.
Personal Journal: Optional notes with mood entries.
Mood History: Displays previously saved entries.
Delete Entries: Allow users to delete individual mood records.
Secure Key Storage: Stores the encryption key using the flutter secure storage.
5-4-3-2-1 Grounding exercise: Interactive exercise to help users reconnect with the present moment.

## 5. Data Model:
Each mood entry contains:
Mood.
Intensity.
Journal Note.
Date and Time.

## 6. Testing:
The application was tested on an android device. The following were verified:
Application launches successfully.
Navigation between screen works.
Mood Selection and saving works.
Journal notes and intensity are saved.
Mood history displays saved entries.
Mood deletion works.
Grounding exercise runs successfully but needs improvement.
 
 ## 7. Development Status:
 Week1-MOdel 1: Completed and tested.
 Core Module 1 requirements have been implemented, alongwith the additional features listed above.
 Further development may include breathing exercises, mood charts, biometric/PIN, security, and emergency helpline information.

## 8. How to Run:
git clone GITHUB_REPOSITORY_LINK
cd mindcheck
flutter pub get
flutter run

 ## 9. Conclusion
 Mindcheck provides a fooundation for a personal mental wellness application. Module 1 established the flutter project structure, theme, navigation, and initial screens, while additional development included functional mood tracking, encrypted local storage, mood history, deletion, and grounding exercises.

 ## MODULE  02: Mood Tracking & Journal Management
  The second module focused on implementing the core mood tracking and journal management functionality.

  1. MOOD SELECTION:
  Users can select from seven predefined moods:
  . Happy 
  . Calm
  . Excited
  . Sad
  . Anxious
  . Angry 
  . Tired

  2. DAILY MOOD LOGGING:
  Users can:
  . Select their current mood.
  . Set mood intensity from 1 to 5.
  . Add an optional personal journal note.
  . Save their daily mood entry with its date and time.

  3. JOURNAL ENTRY MANAGEMENT: 
  The application supports all four CRUD operations.
  . Create: Create new mood entries with personal journal notes.
  . Read: View previously saved mood and journal note of an existing entry.
  . Update: Edit the mood, intensity, and journal note of an existing entry.
  . Delete: Delete unwanted entries after confirmation.

Journal functionality is integrated into the mood check-in and history screens.

4. LOCAL DATA STORAGE:
Mood entries are saved locally on the users device.
The application uses:
. SharedPreferences to store encrypted data.
. Flutter Secure Storage to store the encryption key.
. AES-256-GCM encryption to protect saved mood entries.
. JSON serialization and deserialization to manage stored data.
This allows users to access their saved entries without requiring an internet connection.

5. INPUT VALIDATION:
Input validation helps maintain accurate and complete entries.
. Mood input cannot be empty.
. Custom mood is limited to 40 characters.
. Journal notes are limited to 500 characters. 
. Invalid or empty mood entries are prevented from being saved.

6. ADDITIONAL FEATURES: 
The following additional features have also been implemented:
. Search mood entries by mood name or journal note.
. Filter mood history by mood.
. Light and dark mode.
. Local persistence of theme preference.
. Mood intensity progress indicator.

7. TESTING & VERFICATION:
The following functionality has been tested:
. Mood Selection and custom mood input.
. Journal note creation and viewing.
. Editing existing mood and journal entries.
. Deleting entries with confirmation.
. Searching & filtering mood history.
. Local data persistence.
. Light and dark mode switching.
. Application execution on an Android device.

8. Conclusion: 
. First two development modules have established the foundation and core functionality of MindCheck.
 Moudle 1 focused on project setup, application structure, theme design, and the initial user interface.
 Module 2 implemented daily mood tracking, journal entry management, local encrypted storage, input validation.
 The application is now ready for the next development phase, which will focus on weekly mood summaries, guided breathing exercises, wellness tips, & further interface improvements.