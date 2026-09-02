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
    
    static func needsAttentionItems(subscriptions: [SubscriptionModel]) -> [SubscriptionModel] {
        // Items that are trials ending soon (<= 7 days) or subscriptions renewing soon (<= 3 days)
        subscriptions.filter { sub in
            guard sub.status == .active, let days = sub.daysUntilRenewal() else { return false }
            if sub.type == .trial {
                return days >= 0 && days <= 7
            }
            return days >= 0 && days <= 2
        }.sorted { ($0.daysUntilRenewal() ?? 999) < ($1.daysUntilRenewal() ?? 999) }
    }
}
