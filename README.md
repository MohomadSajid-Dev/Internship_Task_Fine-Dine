# 🍽️ FINE DINE — Premium Restaurant Ordering Application

A high-end, luxury Sri Lankan dining mobile application built with Flutter. Experience a premium, Michelin-star-inspired user interface featuring authentic local cuisine, smooth transitions, custom animations, and a polished user flow.

---

## 🎨 Visual Identity & Design System

*   **Brand Personality:** Luxury, High-End Gastronomy, Michelin-Star Aesthetic.
*   **Color Palette:**
    *   `Espresso Brown` (`#2E1B0E`) — Primary brand color representing richness and warmth.
    *   `Warm Gold` (`#C9A66B`) — Accents and highlights signaling quality and premium status.
    *   `Cream / Soft Beige` (`#FFF9F3` / `#F2E6D8`) — Clean, elegant backgrounds.
    *   `Charcoal` (`#2C3E50`) — High-contrast, readable typography.
*   **Typography:**
    *   `Playfair Display` — Used for headings, brand names, and large titles to convey elegance.
    *   `Inter` — Clean, highly legible sans-serif for body text, details, and price tags.
*   **Layout Elements:** Custom glassmorphism overlays, 24px–32px rounded corners, subtle shadows, and top-tier food photography.

---

## 🚀 Key Features

*   **Splash Screen:** High-end intro featuring a self-animating luxury monogram logo and clean CTA.
*   **Onboarding:** Horizontal paging walkthrough showcasing gorgeous culinary images with page indicator dots.
*   **Login & Authentication:** Beautiful glassmorphic credentials card with validation and simulated social login options.
*   **Home Dashboard:**
    *   Interactive Search bar with loading states.
    *   Custom PageView promo banner carousel.
    *   "Today Chef Selections" horizontal slider.
    *   Horizontal Category ChoiceChips selector (All, Specials, Hoppers, Seafood, Short Eats, Desserts, Drinks, Vegetarian).
    *   Grid view of "Popular Dishes" with interactive favoriting.
*   **Food Details Screen:** Hero image transitions, expandable ingredients, meal availability badge, review logs, and automated suggestions.
*   **Cart & Checkout:** Quantity increment/decrement, item deletion, interactive promo code verification, tax/delivery calculation, and a simulated checkout flow.
*   **Order Success Screen:** Completed order screen featuring a custom falling confetti particle system, timeline tracking, and receipts.

---

## ✨ Additional Polish & UX Enhancements

Beyond the basic requirements, the following features and adjustments were introduced to deliver a production-ready, perfect experience:

1.  **Sri Lankan Gastronomy Integration:** Tailored the menu data to feature **20+ authentic Sri Lankan dishes** (Kottu, Hoppers, Ceylon Seafood, Watalappam, etc.) with real descriptions, pricing in LKR (`Rs.`), and a new availability metric (Breakfast, Lunch, Dinner) instead of calorie counters.
2.  **Custom Animated Monogram Logo:** Built a fully custom-painted vector logo (`LuxuryMonogram`) featuring a drawing-in fork/spoon vector stroke animation, rotating outer ring, and a pulsing glow.
3.  **Lottie Preloader Overlay:** Added a custom `restaurant_preloader.json` Lottie animation that plays for 3 seconds when navigating inside the main app to simulate background database fetching and data loading.
4.  **Premium Promo Banners:** Replaced basic layouts with custom coded banners highlighting "Welcome to Fine Dine!" (offering a 25% discount for new users using code `FINEDINE20`) and "Delivered to You!" (up to 20% off with inline "Order Now" shortcuts).
5.  **Card Layout Fixes:** Adjusted the rating star layout inside the "Today Chef Selections" cards, shifting them upward by 20px to prevent overlaps with the overlapping circular orange Add to Cart button.
6.  **Optimized Fonts:** Standardized all pricing tags across the Home, Search, Details, and Cart screens to use the clean sans-serif `Inter` font for a cleaner, modern look.
7.  **Clean Code Practices:** Cleaned up comment noise across the codebase, ensuring comments are written concisely and strictly in natural English.

---

## 🛠️ Step-by-Step Installation & Setup

Follow these instructions to download, configure, and run the project locally on your machine.

### 1. Prerequisites
Ensure you have the following installed on your system:
*   [Git](https://git-scm.com/)
*   [Flutter SDK](https://docs.flutter.dev/get-started/install) (v3.12.0 or newer recommended)
*   An Android/iOS Emulator or physical testing device configured.

### 2. Clone the Repository
Open a terminal (or command prompt) and run:
```bash
git clone <repository_url>
cd Internship_Task
```

### 3. Fetch Dependencies
Install all required package dependencies defined in `pubspec.yaml`:
```bash
flutter pub get
```

### 4. Run the Code Analyzer
Check the codebase for any static analysis warnings or errors:
```bash
flutter analyze
```

### 5. Run the Widget/Unit Tests
Run the test suites to ensure model functionality, state management, and splash screen flows work correctly:
```bash
flutter test
```

### 6. Run the Application
Start the application on your connected device/emulator:
```bash
flutter run
```

### 7. Build Release APK (Android)
To compile a production-ready release APK, run:
```bash
flutter build apk --release
```
*The compiled APK file will be saved to:*  
`build/app/outputs/flutter-apk/app-release.apk`

---

## 🔑 Credentials & Promo Codes

*   **Test Login Credentials (UI-Only Validation):**
    *   **Email:** `user@example.com`
    *   **Password:** `123456` (Min. 6 characters required)
*   **Promo Discount Code:**
    *   **Code:** `FINEDINE20`
    *   **Benefit:** Applies a 20% discount on the cart subtotal.

---

## 🗺️ Application Screen Flow
```
[Splash Screen (Animated Logo)] 
       │
       ▼
[Onboarding Walkthrough] 
       │
       ▼
[Login Screen (Glassmorphic Form)] 
       │
       ▼
[Main Shell (Lottie Preloader Overlay Runs 3s)]
       │
       ├─► [Home Dashboard] ◄───► [Food Details Screen]
       │         ▲                      │
       │         │                      ▼
       ├─► [Search / Filter]     [Add to Cart]
       │                                │
       ├─► [Cart Screen] ◄──────────────┘
       │         │
       │         ▼
       │   [Place Order]
       │         │
       │         ▼
       ├─► [Order Success Screen (Confetti Particle Animation)]
       │         │
       │         ▼
       ├─► [Orders Screen]
       │
       └─► [Profile Screen]
```
