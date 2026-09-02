//
//  TopSubscriptionsCard.swift
//  Renewly
//

import SwiftUI

struct TopSubscriptionsCard: View {
    let subscriptions: [SubscriptionModel]
    var currency: String = "£"
    let onSelectSubscription: (SubscriptionModel) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text("Biggest monthly costs")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.renewlyTextPrimary)
                
                Spacer()
                
                Text("Normalized /mo")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.renewlyTextMuted)
            }
            
            if subscriptions.isEmpty {
                Text("No active subscriptions.")
                    .font(.system(size: 13))
                    .foregroundColor(.renewlyTextSecondary)
                    .padding(.vertical, 8)
            } else {
                VStack(spacing: 0) {
                    ForEach(Array(subscriptions.enumerated()), id: \.element.id) { index, sub in
                        Button(action: {
                            let impact = UIImpactFeedbackGenerator(style: .light)
                            impact.impactOccurred()
                            onSelectSubscription(sub)
                        }) {
                            HStack(spacing: 12) {
                                // Rank indicator
                                Text("\(index + 1)")
                                    .font(.system(size: 12, weight: .bold, design: .rounded))
                                    .foregroundColor(index == 0 ? Color.renewlyPrimary : Color.renewlyTextMuted)
                                    .frame(width: 16)
                                
                                // Service Icon
                                ServiceIconView(
                                    name: sub.name,
                                    iconAssetName: sub.iconAssetName,
                                    sfSymbolName: sub.sfSymbolName,
                                    brandColorHex: sub.brandColorHex,
                                    size: 38
                                )
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    HStack(spacing: 6) {
                                        Text(sub.name)
                                            .font(.system(size: 14, weight: .bold))
                                            .foregroundColor(.renewlyTextPrimary)
                                        
                                        if sub.type == .trial {
                                            TrialBadgeView(text: "TRIAL", isUrgent: false)
                                        }
                                    }
                                    
                                    Text(sub.billingFrequency.rawString)
                                        .font(.system(size: 12))
                                        .foregroundColor(.renewlyTextSecondary)
                                }
                                
                                Spacer()
                                
                                let monthlyCost = sub.type == .trial ? (sub.priceAfterTrial ?? 0.0) : sub.monthlyEquivalentCost
                                Text(String(format: "%@%.2f/mo", sub.currency, monthlyCost))
                                    .font(.system(size: 14, weight: .bold, design: .rounded))
                                    .foregroundColor(.renewlyTextPrimary)
                                
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(.renewlyTextMuted)
                            }
                            .padding(.vertical, 10)
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        if index < subscriptions.count - 1 {
                            Divider()
                                .background(Color.renewlyDivider)
                                .padding(.leading, 70)
                        }
                    }
                }
            }
        }
        .padding(18)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(Color.renewlyCardBorder, lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.02), radius: 4, y: 1)
    }
}
