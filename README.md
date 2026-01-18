# Exam Q&A

A Flutter-based exam simulation app for study, designed for mobile screen sizes and web deployment. The app randomly selects questions from a CSV question bank and provides an interactive learning experience.

## Features

- 📚 Random question selection from CSV question bank
- ✅ Multiple choice questions (4 options)
- 💡 Instant feedback with correct answer display
- 📖 Detailed explanations for each question
- 📱 Mobile-responsive design
- 🌐 Web-compatible (can be deployed as a website)
- 📦 Easy to port to mobile apps (iOS/Android)

## Project Structure

```
ExamQnA/
├── lib/
│   ├── main.dart                 # App entry point
│   ├── models/
│   │   └── question.dart         # Question data model
│   ├── services/
│   │   └── csv_parser.dart       # CSV parsing service
│   └── screens/
│       └── exam_screen.dart      # Main exam screen UI
├── assets/
│   └── questions.csv             # Question bank CSV file
├── pubspec.yaml                  # Flutter dependencies
└── README.md                     # This file
```

## CSV Format

The question bank CSV file should follow this format:

```csv
category,question,choiceA,choiceB,choiceC,choiceD,correctAnswer,explanation
"Geography","What is the capital of France?","London","Berlin","Paris","Madrid","C","Paris is the capital..."
```

**Columns:**
1. `category` - The category of the question (e.g., Geography, Mathematics, Science)
2. `question` - The question text
3. `choiceA` - First choice option
4. `choiceB` - Second choice option
5. `choiceC` - Third choice option
6. `choiceD` - Fourth choice option
7. `correctAnswer` - The correct answer (A, B, C, or D)
8. `explanation` - Detailed explanation of the answer

## Setup

1. **Install Flutter dependencies:**
   ```bash
   flutter pub get
   ```

2. **Update the question bank:**
   - Edit `assets/questions.csv` with your questions
   - Follow the CSV format described above

3. **Run the app:**
   ```bash
   # For web
   %USERPROFILE%\develop\flutter\bin\flutter run -d chrome
   
   # For mobile (iOS)
   flutter run -d ios
   
   # For mobile (Android)
   flutter run -d android
   ```

## Building for Production

### Web
```bash
flutter build web
```

**Important:** After building for web, you cannot open the `index.html` file directly from the file system. You must serve it through an HTTP server:

**Option 1: Use Flutter's development server (recommended)**
```bash
flutter run -d chrome
```

**Option 2: Serve the built files with a local HTTP server**

After building, navigate to the build directory and start a server:

**Using Python:**
```bash
cd build/web
python -m http.server 8000
```
Then open `http://localhost:8000` in your browser.

**Using Node.js:**
```bash
cd build/web
npx http-server -p 8000
```

**Using PHP:**
```bash
cd build/web
php -S localhost:8000
```

**Why?** Modern browsers block JavaScript files loaded from `file://` URLs due to CORS (Cross-Origin Resource Sharing) security restrictions. Flutter web apps must be served over HTTP.

### iOS
```bash
flutter build ios
```

### Android
```bash
flutter build apk
# or
flutter build appbundle
```

## Usage

1. Launch the app
2. A random question from the question bank will be displayed
3. Select one of the four answer choices
4. The correct answer will be highlighted, and an explanation will appear
5. Click "Next Question" to get another random question
6. Repeat to practice and study

## Customization

- **Colors**: Modify the theme in `lib/main.dart`
- **Question Bank**: Update `assets/questions.csv` with your own questions
- **UI**: Customize the exam screen in `lib/screens/exam_screen.dart`

## Requirements

- Flutter SDK (>=3.0.0)
- Dart SDK (>=3.0.0)

## Dependencies

- `csv: ^6.0.0` - For parsing CSV files
- Flutter SDK - Core framework

## License

This project is open source and available for educational purposes.

