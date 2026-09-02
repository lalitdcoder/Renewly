//
//  SubscriptionModel.swift
//  Renewly
//

import SwiftUI
import SwiftData

@Model
final class SubscriptionModel: Identifiable {
    var id: UUID
    var name: String
    var iconAssetName: String?
    var sfSymbolName: String
    var brandColorHex: String
    var categoryRaw: String
    var typeRaw: String
    var price: Double
    var currency: String
    var billingFrequencyType: String
    var billingCustomDays: Int
    var startDate: Date?
    var nextRenewalDate: Date?
    var hasUnknownRenewalDate: Bool
    var trialDurationDays: Int?
    var priceAfterTrial: Double?
    var statusRaw: String
    var reminderDaysString: String
    var reminderTime: Date
    var notes: String
    var createdAt: Date
    var updatedAt: Date
    
    init(
        id: UUID = UUID(),
        name: String,
        iconAssetName: String? = nil,
        sfSymbolName: String = "creditcard.fill",
        brandColorHex: String = "6354EC",
        category: SubscriptionCategory = .other,
        type: SubscriptionType = .subscription,
        price: Double = 0.0,
        currency: String = "£",
        billingFrequency: BillingFrequency = .monthly,
        startDate: Date? = Date(),
        nextRenewalDate: Date? = nil,
        hasUnknownRenewalDate: Bool = false,
        trialDurationDays: Int? = nil,
        priceAfterTrial: Double? = nil,
        status: SubscriptionStatus = .active,
        reminderDays: [Int] = [7],
        reminderTime: Date = Calendar.current.date(bySettingHour: 9, minute: 0, second: 0, of: Date()) ?? Date(),
        notes: String = "",
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.iconAssetName = iconAssetName
        self.sfSymbolName = sfSymbolName
        self.brandColorHex = brandColorHex
        self.categoryRaw = category.rawValue
        self.typeRaw = type.rawValue
        self.price = price
        self.currency = currency
        
        switch billingFrequency {
        case .monthly:
            self.billingFrequencyType = "monthly"
            self.billingCustomDays = 30
        case .yearly:
            self.billingFrequencyType = "yearly"
            self.billingCustomDays = 365
        case .weekly:
            self.billingFrequencyType = "weekly"
            self.billingCustomDays = 7
        case .customDays(let days):
            self.billingFrequencyType = "custom"
            self.billingCustomDays = days
        }
        
        self.startDate = startDate
        self.nextRenewalDate = nextRenewalDate
        self.hasUnknownRenewalDate = hasUnknownRenewalDate
        self.trialDurationDays = trialDurationDays
        self.priceAfterTrial = priceAfterTrial
        self.statusRaw = status.rawValue
        self.reminderDaysString = reminderDays.map(String.init).joined(separator: ",")
        self.reminderTime = reminderTime
        self.notes = notes
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    
    // Computed Properties
    var category: SubscriptionCategory {
        get { SubscriptionCategory(rawValue: categoryRaw) ?? .other }
        set { categoryRaw = newValue.rawValue }
    }
    
    var type: SubscriptionType {
        get { SubscriptionType(rawValue: typeRaw) ?? .subscription }
        set { typeRaw = newValue.rawValue }
    }
    
    var status: SubscriptionStatus {
        get { SubscriptionStatus(rawValue: statusRaw) ?? .active }
        set { statusRaw = newValue.rawValue }
    }
    
    var billingFrequency: BillingFrequency {
        get {
            switch billingFrequencyType {
            case "monthly":
                return .monthly
            case "yearly":
                return .yearly
            case "weekly":
                return .weekly
            case "custom":
                return .customDays(billingCustomDays)
            default:
                return .monthly
            }
        }
        set {
            switch newValue {
            case .monthly:
                billingFrequencyType = "monthly"
                billingCustomDays = 30
            case .yearly:
                billingFrequencyType = "yearly"
                billingCustomDays = 365
            case .weekly:
                billingFrequencyType = "weekly"
                billingCustomDays = 7
            case .customDays(let days):
                billingFrequencyType = "custom"
                billingCustomDays = days
            }
        }
    }
    
    var reminderDays: [Int] {
        get {
            if reminderDaysString.isEmpty { return [] }
            return reminderDaysString.components(separatedBy: ",").compactMap(Int.init)
        }
        set {
            reminderDaysString = newValue.map(String.init).joined(separator: ",")
        }
    }
    
    var brandColor: Color {
        Color(hex: brandColorHex)
    }
    
    var monthlyEquivalentCost: Double {
        guard status == .active else { return 0.0 }
        if type == .trial {
            return 0.0
        }
        return price * billingFrequency.monthlyFactor
    }
    
    var yearlyEquivalentCost: Double {
        guard status == .active else { return 0.0 }
        if type == .trial {
            return 0.0
        }
        return price * billingFrequency.yearlyFactor
    }
    
    func daysUntilRenewal(from referenceDate: Date = Date()) -> Int? {
        guard let renewal = nextRenewalDate, !hasUnknownRenewalDate else { return nil }
        let calendar = Calendar.current
        let startOfRef = calendar.startOfDay(for: referenceDate)
        let startOfRenewal = calendar.startOfDay(for: renewal)
        let components = calendar.dateComponents([.day], from: startOfRef, to: startOfRenewal)
        return components.day
    }
    
    func renewalBadgeText(from referenceDate: Date = Date()) -> String {
        guard let days = daysUntilRenewal(from: referenceDate) else {
            return "Not set"
        }
        if days < 0 {
            return "Overdue"
        } else if days == 0 {
            return "Today"
        } else if days == 1 {
            return "1 day"
        } else if days < 30 {
            return "\(days) days"
        } else {
            let months = max(1, days / 30)
            return months == 1 ? "1 month" : "\(months) months"
        }
    }
    
    func formattedPriceAndFrequency() -> String {
        if type == .trial {
            if let postPrice = priceAfterTrial, postPrice > 0 {
                return String(format: "%@%.2f / month afterwards", currency, postPrice)
            }
            return "Free Trial"
        }
        return String(format: "%@%.2f %@", currency, price, billingFrequency.shortLabel)
    }
    
    func statusSubtitle(from referenceDate: Date = Date()) -> String {
        switch status {
        case .paused:
            return "⏸️ Paused"
        case .cancelled:
            return "🚫 Cancelled"
        case .expired:
            return "Expired"
        case .active:
            if type == .trial {
                if let days = daysUntilRenewal(from: referenceDate) {
                    if days == 0 {
                        return "Trial ends today"
                    } else if days == 1 {
                        return "Trial ends tomorrow"
                    } else if days > 1 {
                        return "Trial ends in \(days) days"
                    } else {
                        return "Trial ended"
                    }
                }
                return "Trial active"
            }
            
            if hasUnknownRenewalDate || nextRenewalDate == nil {
                return "Renewal date not set"
            }
            
            if let days = daysUntilRenewal(from: referenceDate) {
                if days == 0 {
                    return "Renews today"
                } else if days == 1 {
                    return "Renews tomorrow"
                } else if days > 1 && days <= 30 {
                    return "Renews in \(days) days"
                } else if days > 30 {
                    let formatter = DateFormatter()
                    formatter.dateFormat = "MMM d"
                    return "Renews " + formatter.string(from: nextRenewalDate ?? referenceDate)
                } else {
                    return "Renewed recently"
                }
            }
            return "Active"
        }
    }
    
    var isUrgent: Bool {
        guard status == .active else { return false }
        if let days = daysUntilRenewal(), days <= 3 && days >= 0 {
            return true
        }
        return false
    }
}
