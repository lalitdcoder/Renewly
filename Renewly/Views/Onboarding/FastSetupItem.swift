//
//  FastSetupItem.swift
//  Renewly
//

import SwiftUI
import Foundation

struct FastSetupItem: Identifiable, Hashable {
    let id: String
    var name: String
    var iconAssetName: String?
    var sfSymbolName: String
    var brandColorHex: String
    var price: Double
    var currency: String
    var billingFrequency: BillingFrequency
    var renewalDate: Date
    var hasUnknownRenewalDate: Bool
    var category: SubscriptionCategory
    var isTrial: Bool
    var priceAfterTrial: Double?
    
    init(from preset: ServicePreset, currency: String = "£") {
        let calendar = Calendar.current
        let today = Date()
        
        self.id = preset.id
        self.name = preset.name
        self.iconAssetName = preset.iconAssetName
        self.sfSymbolName = preset.sfSymbolName
        self.brandColorHex = preset.brandColorHex
        self.currency = currency
        self.category = preset.category
        
        // Smart defaults
        if preset.defaultTrialDays > 0 && preset.defaultPrice == 0 {
            self.isTrial = true
            self.price = 0.0
            self.priceAfterTrial = 12.99
            self.billingFrequency = .monthly
            self.renewalDate = calendar.date(byAdding: .day, value: preset.defaultTrialDays, to: today) ?? today
            self.hasUnknownRenewalDate = false
        } else {
            self.isTrial = false
            self.price = preset.defaultPrice
            self.priceAfterTrial = nil
            self.billingFrequency = .monthly
            self.renewalDate = calendar.date(byAdding: .day, value: 30, to: today) ?? today
            self.hasUnknownRenewalDate = false
        }
    }
    
    init(customName: String, currency: String = "£") {
        self.id = UUID().uuidString
        self.name = customName
        self.iconAssetName = nil
        self.sfSymbolName = "creditcard.fill"
        self.brandColorHex = "6354EC"
        self.price = 9.99
        self.currency = currency
        self.billingFrequency = .monthly
        self.renewalDate = Calendar.current.date(byAdding: .day, value: 30, to: Date()) ?? Date()
        self.hasUnknownRenewalDate = true
        self.category = .other
        self.isTrial = false
        self.priceAfterTrial = nil
    }
    
    func toSubscriptionModel() -> SubscriptionModel {
        SubscriptionModel(
            name: name,
            iconAssetName: iconAssetName,
            sfSymbolName: sfSymbolName,
            brandColorHex: brandColorHex,
            category: category,
            type: isTrial ? .trial : .subscription,
            price: price,
            currency: currency,
            billingFrequency: billingFrequency,
            startDate: Date(),
            nextRenewalDate: hasUnknownRenewalDate ? nil : renewalDate,
            hasUnknownRenewalDate: hasUnknownRenewalDate,
            priceAfterTrial: isTrial ? priceAfterTrial : nil,
            status: .active,
            reminderDays: [1, 0],
            notes: ""
        )
    }
}
