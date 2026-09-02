//
//  InsightsCalculator.swift
//  Renewly
//

import SwiftUI
import Foundation

struct CategorySpendItem: Identifiable, Equatable {
    let id: String
    let category: SubscriptionCategory
    let monthlyAmount: Double
    let yearlyAmount: Double
    let percentage: Double
    let subscriptionCount: Int
    
    var color: Color {
        switch category {
        case .entertainment: return Color(hex: "E50914")
        case .music: return Color(hex: "1DB954")
        case .cloud: return Color(hex: "3388FF")
        case .productivity: return Color(hex: "00C4CC")
        case .utilities: return Color(hex: "FF9500")
        case .healthAndFitness: return Color(hex: "FF2D55")
        case .education: return Color(hex: "58CC02")
        case .lifestyle: return Color(hex: "AF52DE")
        case .finance: return Color(hex: "007AFF")
        case .other: return Color(hex: "8E8E93")
        }
    }
}

struct SavingsSummary: Equatable {
    let cancelledSubscriptionsAnnualSavings: Double
    let stoppedTrialsSavings: Double
    let totalEstimatedAnnualSavings: Double
    let cancelledCount: Int
    let stoppedTrialCount: Int
    
    var hasSavings: Bool {
        totalEstimatedAnnualSavings > 0
    }
}

struct SpendingTimelinePoint: Identifiable, Equatable {
    let id = UUID()
    let monthLabel: String
    let amount: Double
    let isCurrentOrProjected: Bool
}

struct AutomaticInsightItem: Identifiable, Equatable {
    let id = UUID()
    let icon: String
    let iconColor: Color
    let title: String
    let description: String
}

enum InsightsCalculator {
    
    // MARK: - Category Breakdown
    static func calculateCategoryBreakdown(subscriptions: [SubscriptionModel]) -> [CategorySpendItem] {
        let activeSubs = subscriptions.filter { $0.status == .active && $0.type == .subscription }
        let totalMonthly = activeSubs.reduce(0.0) { $0 + $1.monthlyEquivalentCost }
        
        guard totalMonthly > 0 else { return [] }
        
        var categoryMap: [SubscriptionCategory: (amount: Double, count: Int)] = [:]
        
        for sub in activeSubs {
            let current = categoryMap[sub.category] ?? (0.0, 0)
            categoryMap[sub.category] = (current.amount + sub.monthlyEquivalentCost, current.count + 1)
        }
        
        return categoryMap.map { (cat, data) in
            let percentage = (data.amount / totalMonthly) * 100.0
            return CategorySpendItem(
                id: cat.rawValue,
                category: cat,
                monthlyAmount: data.amount,
                yearlyAmount: data.amount * 12.0,
                percentage: percentage,
                subscriptionCount: data.count
            )
        }.sorted { $0.monthlyAmount > $1.monthlyAmount }
    }
    
    // MARK: - Biggest Subscriptions
    static func calculateBiggestSubscriptions(subscriptions: [SubscriptionModel], limit: Int = 5) -> [SubscriptionModel] {
        let activeSubs = subscriptions.filter { $0.status == .active }
        let sorted = activeSubs.sorted {
            let cost0 = $0.type == .trial ? ($0.priceAfterTrial ?? 0.0) : $0.monthlyEquivalentCost
            let cost1 = $1.type == .trial ? ($1.priceAfterTrial ?? 0.0) : $1.monthlyEquivalentCost
            return cost0 > cost1
        }
        return Array(sorted.prefix(limit))
    }
    
    // MARK: - Savings Calculation
    static func calculateSavings(subscriptions: [SubscriptionModel]) -> SavingsSummary {
        var cancelledAnnualTotal: Double = 0.0
        var cancelledCount = 0
        var stoppedTrialsTotal: Double = 0.0
        var stoppedTrialCount = 0
        
        for sub in subscriptions {
            if sub.status == .cancelled || sub.status == .expired {
                if sub.type == .subscription {
                    // Annual cost avoided
                    cancelledAnnualTotal += sub.price * sub.billingFrequency.yearlyFactor
                    cancelledCount += 1
                } else if sub.type == .trial {
                    // Trial stopped before turning into paid subscription (annualized avoided cost)
                    if let postPrice = sub.priceAfterTrial, postPrice > 0 {
                        stoppedTrialsTotal += postPrice * 12.0
                    } else if sub.price > 0 {
                        stoppedTrialsTotal += sub.price * 12.0
                    }
                    stoppedTrialCount += 1
                }
            }
        }
        
        let total = cancelledAnnualTotal + stoppedTrialsTotal
        return SavingsSummary(
            cancelledSubscriptionsAnnualSavings: cancelledAnnualTotal,
            stoppedTrialsSavings: stoppedTrialsTotal,
            totalEstimatedAnnualSavings: total,
            cancelledCount: cancelledCount,
            stoppedTrialCount: stoppedTrialCount
        )
    }
    
    // MARK: - Spending Timeline (Past 6 Months & Projection)
    static func calculateSpendingTimeline(subscriptions: [SubscriptionModel], numberOfMonths: Int = 6) -> [SpendingTimelinePoint] {
        let calendar = Calendar.current
        let today = Date()
        let activeSubs = subscriptions.filter { $0.status == .active && $0.type == .subscription }
        let currentMonthly = activeSubs.reduce(0.0) { $0 + $1.monthlyEquivalentCost }
        
        guard currentMonthly > 0 else { return [] }
        
        var points: [SpendingTimelinePoint] = []
        let monthFormatter = DateFormatter()
        monthFormatter.dateFormat = "MMM"
        
        for i in (0..<numberOfMonths).reversed() {
            guard let monthDate = calendar.date(byAdding: .month, value: -i, to: today) else { continue }
            let monthLabel = monthFormatter.string(from: monthDate)
            
            // Calculate active subscriptions as of that month based on startDate
            let monthStart = calendar.date(from: calendar.dateComponents([.year, .month], from: monthDate)) ?? monthDate
            
            let subsInMonth = subscriptions.filter { sub in
                guard sub.type == .subscription else { return false }
                let start = sub.startDate ?? Date.distantPast
                if start > monthDate { return false }
                
                // If cancelled/expired, check if cancelled before this month
                if (sub.status == .cancelled || sub.status == .expired) {
                    let updated = sub.updatedAt
                    if updated < monthStart {
                        return false
                    }
                }
                return true
            }
            
            let amount = subsInMonth.reduce(0.0) { $0 + $1.monthlyEquivalentCost }
            let displayAmount = amount > 0 ? amount : currentMonthly
            
            points.append(
                SpendingTimelinePoint(
                    monthLabel: monthLabel,
                    amount: displayAmount,
                    isCurrentOrProjected: i == 0
                )
            )
        }
        
        return points
    }
    
    // MARK: - Average Subscription Cost
    static func calculateAverageMonthlyCost(subscriptions: [SubscriptionModel]) -> Double {
        let activeSubs = subscriptions.filter { $0.status == .active && $0.type == .subscription }
        guard !activeSubs.isEmpty else { return 0.0 }
        let totalMonthly = activeSubs.reduce(0.0) { $0 + $1.monthlyEquivalentCost }
        return totalMonthly / Double(activeSubs.count)
    }
    
    // MARK: - Automatic Insights Generation
    static func generateAutomaticInsights(subscriptions: [SubscriptionModel], currency: String) -> [AutomaticInsightItem] {
        var insights: [AutomaticInsightItem] = []
        let activeSubs = subscriptions.filter { $0.status == .active }
        let activePaidSubs = activeSubs.filter { $0.type == .subscription }
        let categories = calculateCategoryBreakdown(subscriptions: subscriptions)
        let savings = calculateSavings(subscriptions: subscriptions)
        
        // 1. Top category insight
        if let topCategory = categories.first, topCategory.percentage > 0 {
            insights.append(
                AutomaticInsightItem(
                    icon: topCategory.category.iconName,
                    iconColor: topCategory.color,
                    title: "\(topCategory.category.rawValue) is your largest category",
                    description: String(format: "Accounting for %.0f%% of your monthly spend (%@%.2f/mo).", topCategory.percentage, currency, topCategory.monthlyAmount)
                )
            )
        }
        
        // 2. Average active subscription cost
        if !activePaidSubs.isEmpty {
            let avg = calculateAverageMonthlyCost(subscriptions: subscriptions)
            insights.append(
                AutomaticInsightItem(
                    icon: "chart.bar.fill",
                    iconColor: Color.renewlyPrimary,
                    title: "Average Subscription Cost",
                    description: String(format: "You pay an average of %@%.2f per active subscription each month.", currency, avg)
                )
            )
        }
        
        // 3. Real savings insight
        if savings.hasSavings {
            insights.append(
                AutomaticInsightItem(
                    icon: "sparkles",
                    iconColor: Color.renewlySuccess,
                    title: "Estimated Savings Avoided",
                    description: String(format: "You've avoided an estimated %@%.2f/year by cancelling %d subscription%@.", currency, savings.totalEstimatedAnnualSavings, savings.cancelledCount + savings.stoppedTrialCount, (savings.cancelledCount + savings.stoppedTrialCount) == 1 ? "" : "s")
                )
            )
        }
        
        // 4. Free trial reminder insight
        let activeTrials = activeSubs.filter { $0.type == .trial }
        if let trial = activeTrials.first {
            let daysLeft = trial.daysUntilRenewal() ?? 0
            insights.append(
                AutomaticInsightItem(
                    icon: "gift.fill",
                    iconColor: Color.renewlyTrialAmber,
                    title: "Active Free Trial: \(trial.name)",
                    description: daysLeft <= 3 ? "Ending in \(daysLeft) days! Cancel soon if you don't want to renew." : "Active trial. We'll remind you before it renews."
                )
            )
        }
        
        return insights
    }
}
