# Renewly 🔄

<p align="center">
  <img src="https://img.shields.io/badge/iOS-17.0+-6354EC?style=for-the-badge&logo=apple&logoColor=white" alt="iOS 17.0+" />
  <img src="https://img.shields.io/badge/Swift-5.9+-FA7343?style=for-the-badge&logo=swift&logoColor=white" alt="Swift 5.9+" />
  <img src="https://img.shields.io/badge/SwiftData-Supported-3388FF?style=for-the-badge&logo=apple&logoColor=white" alt="SwiftData" />
  <img src="https://img.shields.io/badge/Architecture-SwiftUI_Native-5856D6?style=for-the-badge" alt="SwiftUI" />
  <img src="https://img.shields.io/badge/Privacy-100%25_On--Device-34C759?style=for-the-badge" alt="Privacy First" />
</p>

<p align="center">
  <strong>A polished, native iOS subscription and free-trial tracker built with SwiftUI and SwiftData.</strong><br>
  Never get surprised by auto-renewals or unexpected charges again.
</p>

---

## 🌟 Overview

**Renewly** is a native iOS subscription management app crafted to help users effortlessly track recurring expenses, manage free trials before they bill, and discover potential savings.

Designed with Apple Human Interface Guidelines in mind, Renewly features soft shadows, rounded surfaces, confident typography, vibrant brand accents, and fluid interactions that feel completely native to iOS.

---

## ✨ Features

### 📡 1. Renewal Radar ("Coming up")
- **Live Weekly Summary**: Instant overview of charges coming in the next 7 days (e.g. `£29.98 renewing this week`).
- **Real-Time Countdown Badges**: Color-coded countdown badges (`Today`, `1 day`, `3 days`, `6 days`).
- **Direct Access**: Tap any upcoming item to view details, cancel, edit, or manage the subscription.

### 🆓 2. First-Class Free-Trial Tracking
- **Trial Lifecycle Management**: Dedicated free-trial flow with trial start dates, duration (`7`, `14`, `30`, or custom days), and regular post-trial cost tracking.
- **Urgent Trial Alerts**: High-visibility amber badges and ending alerts ($\le 3$ days remaining) so you never miss cancellation deadlines.
- **Filter Chip Tabs**: Quickly toggle between `All`, `Active`, `Trials`, `Paused`, and `Cancelled` subscriptions.

### 🔔 3. Smart Renewal Reminders
- **Flexible Timing Options**: Choose multi-day reminders: **14 days**, **7 days**, **3 days**, **1 day before**, and **on renewal day**.
- **Contextual Notifications**:
  - *Subscriptions*: `Netflix renews in 3 days · £17.99`
  - *Trials*: `Your Canva trial ends in 2 days.`
- **Custom Time of Day**: Configure your preferred notification delivery time (e.g., `09:00 AM`).

### 💡 4. Deep Spending Insights & Potential Savings
- **Money Saved (Avoided Costs)**: Automatically calculates cumulative annual savings achieved by cancelling subscriptions or stopping trials before billing.
- **Potential Savings Breakdown**: Informational, non-judgmental analysis of annualized costs per active service with total potential annual savings (e.g. `£359.76 / year potential savings`).
- **Month-over-Month Comparisons**: Clear trend comparison banner showing shifts in your monthly commitment (e.g. `Your monthly spend increased £32.97 → £44.96 (+£11.99 / month)`).
- **Category Spend Distribution**: Multi-segment visual bar breakdown and itemized monthly/yearly spending per category.
- **Interactive Monthly & Yearly Toggle**: View real-time commitments calculated across all billing frequencies (weekly, monthly, yearly).

### ✨ 5. Subscription Review Prompts ("Worth reviewing?")
- Non-judgmental, periodic review reminders for subscriptions tracked for $\ge 6$ months (*"You've been tracking this subscription for 8 months."*).
- One-tap **"Keep subscription"** (snoozes prompt for 90 days) or **"Review"** to inspect usage.

### 🌐 6. Direct Management & Cancellation Links
- One-tap **"Manage Subscription in Safari"** button on subscription details opening the official cancellation and account settings page (Netflix, Spotify, Apple, Disney+, Prime, YouTube, Canva, and more).

### 📅 7. Interactive Calendar & Apple Calendar (EventKit) Sync
- **Monthly Overview Grid**: Color-coded event indicator dots for upcoming renewal dates (purple) and ending free trials (amber).
- **Date Summary Banner**: Dynamic daily breakdown (e.g. `October 2 · 4 renewals · £44.96`).
- **Native Apple Calendar Export**: Add individual renewals to Apple Calendar with alarms or sync all active subscriptions directly to your device's Calendar.

### 🏷️ 8. Custom Category Manager
- Built-in default categories: *Entertainment, Music, Gaming, Productivity, Storage, Utilities, Health & Fitness, Education, Lifestyle, Finance, Other*.
- Create custom categories with custom icons (SF Symbols) and color palettes, saved locally in `UserDefaults`.

### 📱 9. Home & Lock Screen Widgets
- **Small Widget**: Next upcoming renewal or trial countdown badge.
- **Medium Widget**: Monthly spend total + upcoming renewals radar list.
- **Lock Screen Widget**: Clean rectangular glanceable next renewal view.
- **In-App Widget Preview**: Interactive widget showroom under Settings > Preferences > Home Screen Widgets with setup instructions.

### 🚀 10. Fast Setup Onboarding & Quick Add
- **Fast 3-Step Onboarding**: Pick popular presets, review pre-filled defaults, and start tracking in seconds.
- **Quick Add Sheet**: Single-screen rapid entry with service autocomplete and custom service creator.
- **Detailed Step-by-Step Flow**: Guided 4-step wizard with animated progress bars for comprehensive customization.

### 🔒 11. Privacy-First & 100% On-Device
- All data is stored locally using **SwiftData**.
- No account registration required.
- No third-party trackers or external server dependencies.
- **Data Export & Backup**: Export your complete subscription dataset to **JSON** or **CSV** anytime.

---

## 🛠️ Tech Stack & Architecture

- **Language**: Swift 5.9+ / Swift 6 compatible
- **UI Framework**: SwiftUI (iOS 17+)
- **Data Persistence**: SwiftData (`@Model`, `@Query`, `ModelContext`)
- **Observation**: Swift Observation framework (`@Observable`, `@Bindable`)
- **System Integrations**:
  - `UserNotifications` (`UNUserNotificationCenter`)
  - `EventKit` (`EKEventStore`, `EKEvent`, `EKAlarm`)
  - `UIKit` / `UIActivityViewController` (Data export share sheets)

---

## 📂 Project Structure

```
Renewly/
├── App/
│   └── RenewlyApp.swift                    # App Entry Point & SwiftData Container
├── Models/
│   ├── SubscriptionModel.swift             # SwiftData @Model entity & business helpers
│   ├── SubscriptionCategory.swift          # Category enumerations & styling
│   ├── CategoryManager.swift               # Default & custom categories store
│   ├── ServicePreset.swift                 # Built-in presets with management URLs
│   ├── UserPreferences.swift               # Currency, notification & display preferences
│   └── DataExportManager.swift             # JSON & CSV backup serializer
├── Services/
│   ├── SpendingCalculator.swift            # Monthly/yearly totals & Renewal Radar calculations
│   ├── InsightsCalculator.swift            # Potential savings & month-over-month analysis
│   ├── NotificationManager.swift           # Local notification scheduling & triggers
│   ├── CalendarSyncManager.swift           # EventKit Apple Calendar export & sync
│   └── SampleDataLoader.swift              # Demo subscription fixtures
├── DesignSystem/
│   ├── Theme.swift                         # Color tokens, gradients, typography
│   └── Components/
│       ├── SpendingCard.swift              # Gradient hero spending card
│       ├── RenewalRadarSection.swift       # Weekly renewal summary & upcoming rows
│       ├── SubscriptionCard.swift          # Reusable subscription list item
│       ├── SubscriptionReviewCard.swift    # "Worth reviewing?" prompt card
│       ├── NeedsAttentionCard.swift        # Urgent alert card
│       ├── ServiceIconView.swift           # Dynamic app icon / SF Symbol renderer
│       ├── PrimaryButton.swift             # Standardized pill action button
│       └── TrialBadgeView.swift            # Free trial & urgency pill badges
└── Views/
    ├── MainTabView.swift                   # 5-tab root container
    ├── Home/                               # Dashboard, Radar, Notifications sheet
    ├── Subscriptions/                      # Filterable list, search, detail & edit views
    ├── Calendar/                           # Month calendar grid & day summaries
    ├── Insights/                           # Savings, potential savings, MoM cards & charts
    ├── Onboarding/                         # Fast 3-step setup flow
    ├── AddSubscription/                    # Guided step wizard & Quick Add sheet
    ├── AddFreeTrial/                       # Dedicated free trial creation flow
    └── Settings/                           # Preferences, Categories, Calendar, Widget showroom
```

---

## 🚀 Getting Started

### Prerequisites
- macOS Sonoma (14.0+) or macOS Sequoia (15.0+)
- Xcode 15.0+ or Xcode 16.0+
- iOS 17.0+ Simulator or physical device

### Building & Running
1. Clone the repository:
   ```bash
   git clone https://github.com/lalitdcoder/Renewly.git
   cd Renewly
   ```
2. Open the project in Xcode:
   ```bash
   open Renewly.xcodeproj
   ```
3. Select your desired simulator (e.g. **iPhone 17**) and press `Cmd + R` to build and run.

### Running Unit Tests
Execute the automated test suite via Xcode (`Cmd + U`) or the command line:
```bash
xcodebuild test -scheme Renewly -destination 'platform=iOS Simulator,name=iPhone 17'
```

---

## 🧪 Testing & Validation

Renewly includes a comprehensive unit testing suite (`RenewlyTests`) covering:
- **Spending Calculations**: Multi-currency, yearly-to-monthly prorating, paused/trial exclusions.
- **Renewal Radar**: 7-day and 14-day threshold calculations and weekly summary strings.
- **Potential Savings Engine**: Annualized cost accumulation and itemized calculations.
- **Free-Trial Logic**: Countdown computations, urgency thresholds, and cost after trial.
- **Category Customization**: Creation, deletion, and dynamic resolution of custom categories.
- **Data Export Serialization**: JSON and CSV export schema integrity.

---

## 📄 License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
