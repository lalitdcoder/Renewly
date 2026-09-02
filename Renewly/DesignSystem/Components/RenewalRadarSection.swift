//
//  RenewalRadarSection.swift
//  Renewly
//

import SwiftUI

struct RenewalRadarSection: View {
    let subscriptions: [SubscriptionModel]
    let currency: String
    let onSeeAll: () -> Void
    let onSelectSubscription: (SubscriptionModel) -> Void
    
    private var radarItems: [SubscriptionModel] {
        SpendingCalculator.renewalRadarItems(subscriptions: subscriptions, withinDays: 14)
    }
    
    private var weekSummaryText: String {
        SpendingCalculator.renewalRadarWeekSummary(subscriptions: subscriptions, currency: currency)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Header with title and "See all"
            HStack(alignment: .center) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Renewal Radar")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(.renewlyTextPrimary)
                    
                    Text(weekSummaryText)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.renewlyPrimary)
                }
                
                Spacer()
                
                Button(action: {
                    let impact = UIImpactFeedbackGenerator(style: .light)
                    impact.impactOccurred()
                    onSeeAll()
                }) {
                    HStack(spacing: 4) {
                        Text("See all")
                            .font(.system(size: 13, weight: .semibold))
                        Image(systemName: "chevron.right")
                            .font(.system(size: 10, weight: .bold))
                    }
                    .foregroundColor(.renewlyPrimary)
                    .padding(.vertical, 4)
                    .padding(.horizontal, 6)
                }
            }
            .padding(.horizontal, 24)
            
            // Card container with upcoming radar items
            VStack(spacing: 0) {
                if radarItems.isEmpty {
                    HStack(spacing: 12) {
                        Text("🎉")
                            .font(.system(size: 22))
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("You're all clear")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.renewlyTextPrimary)
                            Text("No renewals or trial endings in the next 14 days.")
                                .font(.system(size: 12))
                                .foregroundColor(.renewlyTextSecondary)
                        }
                        
                        Spacer()
                    }
                    .padding(16)
                } else {
                    ForEach(Array(radarItems.prefix(4).enumerated()), id: \.element.id) { index, sub in
                        RadarSubscriptionRow(subscription: sub) {
                            onSelectSubscription(sub)
                        }
                        
                        if index < min(radarItems.count, 4) - 1 {
                            Divider()
                                .background(Color.renewlyDivider)
                                .padding(.leading, 56)
                        }
                    }
                }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 4)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .stroke(Color.renewlyCardBorder, lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.02), radius: 4, y: 1)
            .padding(.horizontal, 24)
        }
    }
}

struct RadarSubscriptionRow: View {
    let subscription: SubscriptionModel
    let onTap: () -> Void
    
    private var formattedPriceAndDate: String {
        guard let renewal = subscription.nextRenewalDate else { return "Date not set" }
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        let dateStr = formatter.string(from: renewal)
        let planPrefix = subscription.hasPlan ? "\(subscription.planName!) · " : ""
        
        if subscription.type == .trial {
            if let post = subscription.priceAfterTrial {
                return String(format: "%@%@%.2f/mo afterwards · %@", planPrefix, subscription.currency, post, dateStr)
            }
            return "\(planPrefix)Free Trial · \(dateStr)"
        }
        return String(format: "%@%@%.2f · %@", planPrefix, subscription.currency, subscription.price, dateStr)
    }
    
    var body: some View {
        Button(action: {
            let impact = UIImpactFeedbackGenerator(style: .light)
            impact.impactOccurred()
            onTap()
        }) {
            HStack(spacing: 12) {
                ServiceIconView(
                    name: subscription.name,
                    iconAssetName: subscription.iconAssetName,
                    sfSymbolName: subscription.sfSymbolName,
                    brandColorHex: subscription.brandColorHex,
                    size: 40
                )
                
                VStack(alignment: .leading, spacing: 3) {
                    HStack(spacing: 6) {
                        Text(subscription.name)
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(.renewlyTextPrimary)
                            .lineLimit(1)
                        
                        if subscription.type == .trial {
                            TrialBadgeView(text: "TRIAL", isUrgent: subscription.isUrgent)
                        }
                    }
                    
                    Text(formattedPriceAndDate)
                        .font(.system(size: 13, weight: .regular))
                        .foregroundColor(.renewlyTextSecondary)
                }
                
                Spacer()
                
                // Days remaining badge
                Text(subscription.radarCountdownText())
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(subscription.isUrgent ? Color.renewlyAttention : Color.renewlyPrimary)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(subscription.isUrgent ? Color.renewlyAttentionBg : Color.renewlyPrimaryLight)
                    .clipShape(Capsule())
            }
            .padding(.vertical, 10)
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
    }
}
