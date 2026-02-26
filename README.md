# VoxAI Quest 🚀
> **A Premium, Gamified Language Learning Odyssey**

VoxAI Quest is a state-of-the-art language learning platform built with Flutter, designed to transform the educational journey into an immersive, RPG-style adventure. By combining high-fidelity UI design (Glassmorphism) with robust backend infrastructure (Firebase), VoxAI Quest offers a uniquely engaging experience for learners of all ages.

---

## ✨ Key Learning Zones

### 🎙 Speaking & Phonetics
- **Speaking Mastery**: Interactive challenges focusing on situational speaking and scene descriptions.
- **Accent Studio**: Minimal pairs and intonation mimicking for natural pronunciation.
- **Roleplay Arena**: AI-driven branching dialogues and situational responses.

### 📚 Literacy & Understanding
- **Reading Foundations**: Comprehensive comprehension drills and speed-reading checks.
- **Writing Studio**: From sentence building to daily journaling with intelligent feedback.
- **Vocabulary Vault**: Immersive synonym matching and phrasal verb contextualization.
- **Grammar Guide**: Gamified syntax correction and tense mastery.

### 🧒 Kids Zone (Specialized Module)
- **Mascot System**: Interactive buddies (Owly, Panda, etc.) that guide young learners.
- **Stickers Album**: A collectible reward system with 80+ unique stickers and 20 categories.
- **Playful UX**: Organic "Bubbly Island" layout with floating animations and vibrant aesthetics.

---

## 🎮 Gamification Mechanics

- **Vox Treasury**: Centralized currency system (Quest Coins) for in-app rewards.
- **Adventure Hub**: Level maps for every game type with visual progression.
- **Streak System**: Daily engagement rewards with Haptic-powered shop boosters.
- **Command Pod**: A real-time dashboard for XP, Coins, and Mastery stats.
- **Battle Badges**: Visual rewards reflecting level milestones and achievements.

---

## 🛠 Tech Stack & Architecture

### Core Engineering
- **Framework**: [Flutter](https://flutter.dev) (Dart)
- **State Management**: BLoC / Cubit for clean, predictable state transitions.
- **Architecture**: **Clean Architecture** (Data, Domain, Presentation layers).
- **Navigation**: Go_Router for structured, deep-linkable routing.
- **Persistence**: SharedPreferences for local caching and user preferences.

### Backend Infrastructure
- **Firebase Auth**: Secure Google and Email authentication.
- **Cloud Firestore**: Real-time synchronization of user progress, coins, and inventory.
- **Firebase Storage**: Robust hosting for user profile pictures and assets.

### Third-Party Integrations
- **Payment Gateway**: [Razorpay](https://razorpay.com) for premium subscription management.
- **Monetization**: [Google Mobile Ads (AdMob)](https://admob.google.com) integrated rewards system.
- **Typography**: Google Fonts (Outfit, Inter).

---

## 🎨 Visual Identity & UX

- **Glassmorphic UI**: Extensive use of `BackdropFilter`, blur effects, and mesh gradients for a premium feel.
- **Micro-Animations**: Powered by `flutter_animate` for organic, lively transitions.
- **Haptic Design**: Multi-layered haptic feedback (Light to Heavy) for a tactile user experience.
- **Responsive Layout**: Fully adaptive design using `flutter_screenutil`.

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (latest stable version)
- Firebase Account
- Google Mobile Ads SDK Configuration

### Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/voxai-quest-flutter.git
   ```
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Configure Firebase:
   - Run `flutterfire configure` to set up your project environments.
   - Ensure `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) are correctly placed.

4. Launch the app:
   ```bash
   flutter run
   ```

---

## 📄 License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---
*Built with ❤️ for the future of language learning.*
