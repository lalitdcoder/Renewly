//
//  SubscriptionCard.swift
//  Renewly
//

import SwiftUI

struct SubscriptionCard: View {
    let subscription: SubscriptionModel
    let onTap: () -> Void
    
    private var isEndingVerySoon: Bool {
        subscription.isUrgent
    }
    
    var body: some View {
        Button(action: {
            let impact = UIImpactFeedbackGenerator(style: .light)
            impact.impactOccurred()
            onTap()
        }) {
            HStack(spacing: 14) {
                // Icon
                ServiceIconView(
                    name: subscription.name,
                    iconAssetName: subscription.iconAssetName,
                    sfSymbolName: subscription.sfSymbolName,
                    brandColorHex: subscription.brandColorHex,
                    size: 46
                )
                
                // Info
                VStack(alignment: .leading, spacing: 3) {
                    HStack(spacing: 6) {
                        Text(subscription.name)
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(.renewlyTextPrimary)
                        
                        if subscription.type == .trial {
                            TrialBadgeView(text: "TRIAL", isUrgent: isEndingVerySoon)
                        } else if subscription.status != .active {
                            StatusBadgeView(status: subscription.status)
                        }
                    }
                    
                    Text(subscription.formattedPlanAndPrice())
                        .font(.system(size: 13, weight: .regular))
                        .foregroundColor(.renewlyTextSecondary)
                    
                    Text(subscription.statusSubtitle())
                        .font(.system(size: 12, weight: isEndingVerySoon ? .semibold : .regular))
                        .foregroundColor(isEndingVerySoon ? .renewlyAttention : .renewlyTextMuted)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(Color.renewlyTextMuted.opacity(0.7))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .stroke(isEndingVerySoon ? Color.renewlyAttentionBorder.opacity(0.7) : Color.renewlyCardBorder, lineWidth: 1)
            )
            .shadow(color: isEndingVerySoon ? Color.renewlyAttention.opacity(0.03) : Color.black.opacity(0.02), radius: 4, y: 1)
        }
        .buttonStyle(SpringBounceButtonStyle())
        .accessibilityLabel("\(subscription.name). \(subscription.formattedPriceAndFrequency()). \(subscription.statusSubtitle()).")
    }
}
