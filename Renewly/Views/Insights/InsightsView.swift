//
//  InsightsView.swift
//  Renewly
//

import SwiftUI
import SwiftData

struct InsightsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var subscriptions: [SubscriptionModel]
    
    let onAddSubscription: () -> Void
    let onSelectSubscription: (SubscriptionModel) -> Void
    
    @State private var selectedPeriod: InsightsPeriod = .monthly
    
    private var currencySymbol: String {
        UserPreferences.shared.currency.rawValue
    }
    
    private var monthlyTotal: Double {
        SpendingCalculator.totalMonthlySpending(subscriptions: subscriptions)
    }
    
    private var yearlyTotal: Double {
        SpendingCalculator.totalYearlySpending(subscriptions: subscriptions)
    }
    
    private var activeCount: Int {
        subscriptions.filter { $0.status == .active }.count
    }
    
    private var trialCount: Int {
        subscriptions.filter { $0.type == .trial && $0.status == .active }.count
    }
    
    private var pausedCount: Int {
        subscriptions.filter { $0.status == .paused }.count
    }
    
    private var cancelledCount: Int {
        subscriptions.filter { $0.status == .cancelled || $0.status == .expired }.count
    }
    
    private var categoryBreakdown: [CategorySpendItem] {
        InsightsCalculator.calculateCategoryBreakdown(subscriptions: subscriptions)
    }
    
    private var biggestSubscriptions: [SubscriptionModel] {
        InsightsCalculator.calculateBiggestSubscriptions(subscriptions: subscriptions, limit: 5)
    }
    
    private var savingsSummary: SavingsSummary {
        InsightsCalculator.calculateSavings(subscriptions: subscriptions)
    }
    
    private var potentialSavingsSummary: PotentialSavingsSummary {
        InsightsCalculator.calculatePotentialSavings(subscriptions: subscriptions)
    }
    
    private var monthOverMonthComparison: MonthOverMonthSpendComparison {
        InsightsCalculator.calculateMonthOverMonthComparison(subscriptions: subscriptions)
    }
    
    private var timelinePoints: [SpendingTimelinePoint] {
        InsightsCalculator.calculateSpendingTimeline(subscriptions: subscriptions, numberOfMonths: 6)
    }
    
    private var automaticInsights: [AutomaticInsightItem] {
        InsightsCalculator.generateAutomaticInsights(subscriptions: subscriptions, currency: currencySymbol)
    }
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {
                    // Header
                    HStack {
                        Text("Insights")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.renewlyTextPrimary)
                        Spacer()
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 12)
                    
                    if subscriptions.isEmpty {
                        // Empty State
                        emptyStateView
                    } else {
                        // 1. Spending Summary Card
                        InsightsSummaryCard(
                            monthlyAmount: monthlyTotal,
                            yearlyAmount: yearlyTotal,
                            activeCount: activeCount,
                            currency: currencySymbol,
                            selectedPeriod: $selectedPeriod
                        )
                        .padding(.horizontal, 24)
                        
                        // 2. Month-over-Month Comparison (if applicable)
                        if monthOverMonthComparison.hasComparison {
                            MonthOverMonthCard(
                                comparison: monthOverMonthComparison,
                                currency: currencySymbol
                            )
                            .padding(.horizontal, 24)
                        }
                        
                        // 3. Spending Trend (Spending over time)
                        SpendingTrendCard(
                            timelinePoints: timelinePoints,
                            currency: currencySymbol
                        )
                        .padding(.horizontal, 24)
                        
                        // 4. Money Saved & Potential Savings Card
                        SavingsCard(
                            savings: savingsSummary,
                            potentialSavings: potentialSavingsSummary,
                            currency: currencySymbol
                        )
                        .padding(.horizontal, 24)
                        
                        // 5. Spending by Category Card
                        CategorySpendingCard(
                            categories: categoryBreakdown,
                            currency: currencySymbol,
                            isYearly: selectedPeriod == .yearly
                        )
                        .padding(.horizontal, 24)
                        
                        // 6. Biggest Monthly Costs Card
                        TopSubscriptionsCard(
                            subscriptions: biggestSubscriptions,
                            currency: currencySymbol,
                            onSelectSubscription: onSelectSubscription
                        )
                        .padding(.horizontal, 24)
                        
                        // 7. Subscription Overview Card
                        SubscriptionOverviewCard(
                            activeCount: activeCount,
                            trialCount: trialCount,
                            pausedCount: pausedCount,
                            cancelledCount: cancelledCount
                        )
                        .padding(.horizontal, 24)
                        
                        // 8. Automatic Insights Card
                        if !automaticInsights.isEmpty {
                            AutomaticInsightsCard(insights: automaticInsights)
                                .padding(.horizontal, 24)
                        }
                    }
                }
                .padding(.bottom, 32)
            }
            .background(Color.renewlyBackground.ignoresSafeArea())
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Spacer(minLength: 40)
            
            ZStack {
                Circle()
                    .fill(Color.renewlyPrimaryLight)
                    .frame(width: 80, height: 80)
                
                Image(systemName: "chart.pie.fill")
                    .font(.system(size: 36))
                    .foregroundColor(.renewlyPrimary)
            }
            
            VStack(spacing: 8) {
                Text("Start tracking to see your insights")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.renewlyTextPrimary)
                    .multilineTextAlignment(.center)
                
                Text("Once you add subscriptions, we'll show your spending trends, category breakdown, and money saved.")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.renewlyTextSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }
            
            PrimaryButton(title: "+ Add Subscription", action: onAddSubscription)
                .padding(.horizontal, 32)
                .padding(.top, 12)
            
            Spacer(minLength: 40)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
    }
}
