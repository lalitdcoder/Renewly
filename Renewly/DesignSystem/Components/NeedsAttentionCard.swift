//
//  NeedsAttentionCard.swift
//  Renewly
//

import SwiftUI

struct NeedsAttentionCard: View {
    let subscription: SubscriptionModel
    let onTap: () -> Void
    
    var body: some View {
        Button(action: {
            let impact = UIImpactFeedbackGenerator(style: .medium)
            impact.impactOccurred()
            onTap()
        }) {
            HStack(spacing: 14) {
                // Service Icon
                ServiceIconView(
                    name: subscription.name,
                    iconAssetName: subscription.iconAssetName,
                    sfSymbolName: subscription.sfSymbolName,
                    brandColorHex: subscription.brandColorHex,
                    size: 46
                )
                
                // Details
                VStack(alignment: .leading, spacing: 3) {
                    HStack(spacing: 6) {
                        Text(subscription.name)
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(.renewlyTextPrimary)
                        
                        if subscription.type == .trial {
                            TrialBadgeView(text: "TRIAL", isUrgent: true)
                        }
                    }
                    
                    Text(subscription.statusSubtitle())
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.renewlyAttention)
                    
                    if let postTrialPrice = subscription.priceAfterTrial {
                        Text(String(format: "%@%.2f/month afterwards", subscription.currency, postTrialPrice))
                            .font(.system(size: 12, weight: .regular))
                            .foregroundColor(.renewlyTextSecondary)
                    }
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(Color.renewlyTextMuted.opacity(0.8))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .stroke(Color.renewlyAttentionBorder.opacity(0.8), lineWidth: 1)
            )
            .shadow(color: Color.renewlyAttention.opacity(0.04), radius: 8, y: 2)
        }
        .buttonStyle(SpringBounceButtonStyle())
        .accessibilityLabel("\(subscription.name). \(subscription.statusSubtitle()). Tap to view details.")
    }
}
