# Pictionis 🎨

A real-time collaborative drawing application built with Flutter and Firebase.

## 📱 Features

- **Collaborative drawing**: Draw with other users in real-time
- **Real-time synchronization**: Changes are instantly visible to all participants
- **Intuitive interface**: Simple and responsive interface for optimal user experience
- **Cross-platform**: Works on iOS, Android and Web

## 🛠️ Technologies used

- **Flutter**: Cross-platform development framework
- **Firebase**: Backend-as-a-Service for real-time synchronization
  - Firestore: Real-time NoSQL database
  - Firebase Hosting: Web application hosting (convenient for quick testing)
- **Dart**: Programming language

## 🚀 Installation

### Prerequisites
- Flutter SDK
- Dart SDK
- A configured Firebase project

### Installation steps

1. **Clone the project**
   ```bash
   git clone https://github.com/Martriss/pictionis.git
   cd pictionis
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Firebase configuration**
   - Create a Firebase project
   - Use flutterfire to configure Firebase
   - Configure Firestore rules

4. **Run the application**
   ```bash
   # For web
   flutter run -d chrome

   # For mobile
   flutter run
   ```

## 🎯 Usage

1. Launch the application
2. Join a drawing session or create a new one
3. Start drawing - your changes will appear in real-time for all participants
4. Collaborate and create together!

## 🎓 Context

Academic project developed as part of a course on collaborative mobile application development.
