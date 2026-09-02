//
//  HomeView.swift
//  Renewly
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var subscriptions: [SubscriptionModel]
    
    @Binding var selectedTab: AppTab
    let onAddSubscription: () -> Void
    let onSelectSubscription: (SubscriptionModel) -> Void
    
    @State private var showNotificationsSheet = false
    
    private var monthlyTotal: Double {
        SpendingCalculator.totalMonthlySpending(subscriptions: subscriptions)
    }
    
    private var yearlyTotal: Double {
        SpendingCalculator.totalYearlySpending(subscriptions: subscriptions)
    }
    
    private var attentionItems: [SubscriptionModel] {
        SpendingCalculator.needsAttentionItems(subscriptions: subscriptions)
    }
    
    private var upcomingItems: [SubscriptionModel] {
        SpendingCalculator.upcomingRenewals(subscriptions: subscriptions, limit: 3)
    }
    
    private var reviewCandidates: [SubscriptionModel] {
        SpendingCalculator.reviewCandidateItems(subscriptions: subscriptions)
    }
    
    private var currencySymbol: String {
        UserPreferences.shared.currency.rawValue
    }
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 18) {
                    // Header matching Screen 04: "Good morning 👋" + Bell
                    HStack {
                        Text("Good morning 👋")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.renewlyTextPrimary)
                        
                        Spacer()
                        
                        Button(action: {
                            let impact = UIImpactFeedbackGenerator(style: .light)
                            impact.impactOccurred()
                            showNotificationsSheet = true
                        }) {
                            ZStack(alignment: .topTrailing) {
                                Image(systemName: "bell")
                                    .font(.system(size: 19, weight: .semibold))
                                    .foregroundColor(.renewlyTextPrimary)
                                
                                if !attentionItems.isEmpty {
                                    Circle()
                                        .fill(Color.renewlyAttention)
                                        .frame(width: 8, height: 8)
                                        .offset(x: 2, y: -2)
                                }
                            }
                            .frame(width: 38, height: 38)
                            .background(Color.white)
                            .clipShape(Circle())
                            .overlay(
                                Circle().stroke(Color.renewlyCardBorder, lineWidth: 1)
                            )
                            .shadow(color: Color.black.opacity(0.03), radius: 3, y: 1)
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 12)
                    
                    if subscriptions.isEmpty {
                        // Empty State
                        emptyStateView
                    } else {
                        // Spending Card matching Screen 04
                        VStack(spacing: 8) {
                            SpendingCard(
                                monthlyAmount: monthlyTotal,
                                yearlyAmount: yearlyTotal,
                                currency: currencySymbol
                            )
                            
                            // Subtle Insights Link
                            HStack {
                                Spacer()
                                Button(action: {
                                    let impact = UIImpactFeedbackGenerator(style: .light)
                                    impact.impactOccurred()
                                    withAnimation {
                                        selectedTab = .insights
                                    }
                                }) {
                                    HStack(spacing: 4) {
                                        Text("View Insights")
                                            .font(.system(size: 13, weight: .semibold))
                                        Image(systemName: "arrow.right")
                                            .font(.system(size: 11, weight: .bold))
                                    }
                                    .foregroundColor(.renewlyPrimary)
                                    .padding(.vertical, 2)
                                    .padding(.horizontal, 8)
                                }
                            }
                        }
                        .padding(.horizontal, 24)
                        
                        // "Needs attention" Section matching Screen 04
                        if let attentionItem = attentionItems.first {
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text("Needs attention")
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(.renewlyTextSecondary)
                                    
                                    Spacer()
                                }
                                
                                NeedsAttentionCard(subscription: attentionItem) {
                                    onSelectSubscription(attentionItem)
                                }
                            }
                            .padding(.horizontal, 24)
                        }
                        
                        // Renewal Radar Section ("Coming up" + Weekly Summary)
                        RenewalRadarSection(
                            subscriptions: subscriptions,
                            currency: currencySymbol,
                            onSeeAll: {
                                withAnimation {
                                    selectedTab = .subs
                                }
                            },
                            onSelectSubscription: onSelectSubscription
                        )
                        
                        // "Worth reviewing?" Card (Periodic calm review prompt)
                        if let reviewItem = reviewCandidates.first {
                            VStack(alignment: .leading, spacing: 8) {
                                SubscriptionReviewCard(
                                    subscription: reviewItem,
                                    onKeep: {
                                        withAnimation {
                                            reviewItem.snoozeReview()
                                            try? modelContext.save()
                                        }
                                    },
                                    onReview: {
                                        onSelectSubscription(reviewItem)
                                    }
                                )
                            }
                            .padding(.horizontal, 24)
                        }
                        
                        // Action Button matching Screen 04: "+ Add Subscription"
                        PrimaryButton(
                            title: "+ Add Subscription",
                            action: onAddSubscription
                        )
                        .padding(.horizontal, 24)
                        .padding(.top, 4)
                        .padding(.bottom, 24)
                    }
                }
            }
            .background(Color.renewlyBackground.ignoresSafeArea())
            .sheet(isPresented: $showNotificationsSheet) {
                NotificationsSheetView(subscriptions: subscriptions)
            }
        }
    }
    
    // Empty state matching design philosophy
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Spacer(minLength: 40)
            
            ZStack {
                Circle()
                    .fill(Color.renewlyPrimaryLight)
                    .frame(width: 80, height: 80)
                
                Image(systemName: "sparkles")
                    .font(.system(size: 36))
                    .foregroundColor(.renewlyPrimary)
            }
            
            VStack(spacing: 8) {
                Text("Nothing to track yet")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.renewlyTextPrimary)
                
                Text("Add your first subscription or trial and we'll help you remember when it renews.")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.renewlyTextSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }
            
            VStack(spacing: 12) {
                PrimaryButton(title: "+ Add Subscription", action: onAddSubscription)
                
                Button("Load Demo Subscriptions") {
                    SampleDataLoader.seedIfNeeded(modelContext: modelContext)
                }
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.renewlyPrimary)
                .padding(.top, 4)
            }
            .padding(.horizontal, 24)
            .padding(.top, 16)
            
            Spacer(minLength: 40)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
    }
}
