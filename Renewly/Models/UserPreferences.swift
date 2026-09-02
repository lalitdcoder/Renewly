//
//  UserPreferences.swift
//  Renewly
//

import SwiftUI
import Combine

enum CurrencyOption: String, CaseIterable, Identifiable {
    case gbp = "£"
    case usd = "$"
    case eur = "€"
    case jpy = "¥"
    case cad = "CA$"
    case aud = "AU$"
    
    var id: String { rawValue }
    
    var code: String {
        switch self {
        case .gbp: return "GBP"
        case .usd: return "USD"
        case .eur: return "EUR"
        case .jpy: return "JPY"
        case .cad: return "CAD"
        case .aud: return "AUD"
        }
    }
    
    var name: String {
        switch self {
        case .gbp: return "British Pound (£)"
        case .usd: return "US Dollar ($)"
        case .eur: return "Euro (€)"
        case .jpy: return "Japanese Yen (¥)"
        case .cad: return "Canadian Dollar (CA$)"
        case .aud: return "Australian Dollar (AU$)"
        }
    }
}

enum AppAppearance: String, CaseIterable, Identifiable {
    case system = "system"
    case light = "light"
    case dark = "dark"
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .system: return "System"
        case .light: return "Light"
        case .dark: return "Dark"
        }
    }
}

enum WeekStartDay: String, CaseIterable, Identifiable {
    case monday = "monday"
    case sunday = "sunday"
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .monday: return "Monday"
        case .sunday: return "Sunday"
        }
    }
    
    var weekdayIndex: Int {
        switch self {
        case .monday: return 2
        case .sunday: return 1
        }
    }
}

@Observable
final class UserPreferences {
    static let shared = UserPreferences()
    
    var currency: CurrencyOption {
        didSet {
            UserDefaults.standard.set(currency.rawValue, forKey: "user_currency")
        }
    }
    
    var appearance: AppAppearance {
        didSet {
            UserDefaults.standard.set(appearance.rawValue, forKey: "user_appearance")
        }
    }
    
    var weekStart: WeekStartDay {
        didSet {
            UserDefaults.standard.set(weekStart.rawValue, forKey: "user_week_start")
        }
    }
    
    var renewalRemindersEnabled: Bool {
        didSet {
            UserDefaults.standard.set(renewalRemindersEnabled, forKey: "renewal_reminders_enabled")
        }
    }
    
    var trialRemindersEnabled: Bool {
        didSet {
            UserDefaults.standard.set(trialRemindersEnabled, forKey: "trial_reminders_enabled")
        }
    }
    
    var defaultReminderDaysBefore: Int {
        didSet {
            UserDefaults.standard.set(defaultReminderDaysBefore, forKey: "default_reminder_days")
        }
    }
    
    var defaultReminderTime: Date {
        didSet {
            UserDefaults.standard.set(defaultReminderTime.timeIntervalSince1970, forKey: "default_reminder_time")
        }
    }
    
    var hasCompletedOnboarding: Bool {
        didSet {
            UserDefaults.standard.set(hasCompletedOnboarding, forKey: "has_completed_onboarding")
        }
    }
    
    private init() {
        let savedCurrency = UserDefaults.standard.string(forKey: "user_currency") ?? "£"
        self.currency = CurrencyOption(rawValue: savedCurrency) ?? .gbp
        
        let savedAppearance = UserDefaults.standard.string(forKey: "user_appearance") ?? "light"
        self.appearance = AppAppearance(rawValue: savedAppearance) ?? .light
        
        let savedWeekStart = UserDefaults.standard.string(forKey: "user_week_start") ?? "monday"
        self.weekStart = WeekStartDay(rawValue: savedWeekStart) ?? .monday
        
        self.renewalRemindersEnabled = UserDefaults.standard.object(forKey: "renewal_reminders_enabled") as? Bool ?? true
        self.trialRemindersEnabled = UserDefaults.standard.object(forKey: "trial_reminders_enabled") as? Bool ?? true
        self.defaultReminderDaysBefore = UserDefaults.standard.object(forKey: "default_reminder_days") as? Int ?? 7
        
        let savedTime = UserDefaults.standard.double(forKey: "default_reminder_time")
        if savedTime > 0 {
            self.defaultReminderTime = Date(timeIntervalSince1970: savedTime)
        } else {
            self.defaultReminderTime = Calendar.current.date(bySettingHour: 9, minute: 0, second: 0, of: Date()) ?? Date()
        }
        
        self.hasCompletedOnboarding = UserDefaults.standard.bool(forKey: "has_completed_onboarding")
    }
}
