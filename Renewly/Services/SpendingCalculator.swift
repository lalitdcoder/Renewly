//
//  SpendingCalculator.swift
//  Renewly
//

import Foundation

enum SpendingCalculator {
    static func totalMonthlySpending(subscriptions: [SubscriptionModel]) -> Double {
        subscriptions
            .filter { $0.status == .active && $0.type == .subscription }
            .reduce(0.0) { $0 + $1.monthlyEquivalentCost }
    }
    
    static func totalYearlySpending(subscriptions: [SubscriptionModel]) -> Double {
        subscriptions
            .filter { $0.status == .active && $0.type == .subscription }
            .reduce(0.0) { $0 + $1.yearlyEquivalentCost }
    }
    
    static func upcomingRenewals(subscriptions: [SubscriptionModel], limit: Int? = nil) -> [SubscriptionModel] {
        let sorted = subscriptions
            .filter { $0.status == .active && $0.nextRenewalDate != nil && !$0.hasUnknownRenewalDate && $0.type == .subscription }
            .sorted { ($0.nextRenewalDate ?? Date.distantFuture) < ($1.nextRenewalDate ?? Date.distantFuture) }
        
        if let limit = limit {
            return Array(sorted.prefix(limit))
        }
        return sorted
    }
    
    static func needsAttentionItems(subscriptions: [SubscriptionModel], referenceDate: Date = Date()) -> [SubscriptionModel] {
        // Items that are trials ending soon (<= 7 days) or subscriptions renewing soon (<= 3 days)
        subscriptions.filter { sub in
            guard sub.status == .active, let days = sub.daysUntilRenewal(from: referenceDate) else { return false }
            if sub.type == .trial {
                return days >= 0 && days <= 7
            }
            return days >= 0 && days <= 3
        }.sorted { ($0.daysUntilRenewal(from: referenceDate) ?? 999) < ($1.daysUntilRenewal(from: referenceDate) ?? 999) }
    }
    
    // MARK: - Renewal Radar System
    static func renewalRadarItems(subscriptions: [SubscriptionModel], withinDays: Int = 14, referenceDate: Date = Date()) -> [SubscriptionModel] {
        subscriptions.filter { sub in
            guard sub.status == .active, let days = sub.daysUntilRenewal(from: referenceDate) else { return false }
            return days >= 0 && days <= withinDays
        }.sorted { ($0.daysUntilRenewal(from: referenceDate) ?? 999) < ($1.daysUntilRenewal(from: referenceDate) ?? 999) }
    }
    
    static func renewalRadarWeekTotal(subscriptions: [SubscriptionModel], referenceDate: Date = Date()) -> Double {
        let weekItems = renewalRadarItems(subscriptions: subscriptions, withinDays: 7, referenceDate: referenceDate)
        return weekItems
            .filter { $0.type == .subscription }
            .reduce(0.0) { $0 + $1.price }
    }
    
    static func renewalRadarWeekSummary(subscriptions: [SubscriptionModel], currency: String = "£", referenceDate: Date = Date()) -> String {
        let weekItems = renewalRadarItems(subscriptions: subscriptions, withinDays: 7, referenceDate: referenceDate)
        let paidItems = weekItems.filter { $0.type == .subscription }
        let total = paidItems.reduce(0.0) { $0 + $1.price }
        
        if !paidItems.isEmpty && total > 0 {
            return String(format: "%@%.2f renewing this week", currency, total)
        } else if !weekItems.isEmpty {
            return "\(weekItems.count) trial\(weekItems.count == 1 ? "" : "s") ending this week"
        } else {
            let next14 = renewalRadarItems(subscriptions: subscriptions, withinDays: 14, referenceDate: referenceDate)
            if !next14.isEmpty {
                return "\(next14.count) upcoming in next 14 days"
            }
            return "No renewals coming up this week"
        }
    }
    
    // MARK: - Subscription Review Candidates
    static func reviewCandidateItems(subscriptions: [SubscriptionModel], referenceDate: Date = Date()) -> [SubscriptionModel] {
        subscriptions.filter { $0.shouldPromptForReview(from: referenceDate) }
            .sorted { $0.trackingDurationInMonths(from: referenceDate) > $1.trackingDurationInMonths(from: referenceDate) }
    }
    
    // MARK: - Active Trials
    static func activeTrials(subscriptions: [SubscriptionModel]) -> [SubscriptionModel] {
        subscriptions.filter { $0.status == .active && $0.type == .trial }
            .sorted { ($0.daysUntilRenewal() ?? 999) < ($1.daysUntilRenewal() ?? 999) }
    }
}
