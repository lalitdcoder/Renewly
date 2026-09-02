//
//  UpcomingSubscriptionRow.swift
//  Renewly
//

import SwiftUI

struct UpcomingSubscriptionRow: View {
    let subscription: SubscriptionModel
    let onTap: () -> Void
    
    private var formattedDateText: String {
        guard let renewal = subscription.nextRenewalDate else { return "Date not set" }
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        let dateStr = formatter.string(from: renewal)
        return String(format: "%@%.2f · %@", subscription.currency, subscription.price, dateStr)
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
                            TrialBadgeView(text: "TRIAL", isUrgent: false)
                        }
                    }
                    
                    Text(formattedDateText)
                        .font(.system(size: 13, weight: .regular))
                        .foregroundColor(.renewlyTextSecondary)
                }
                
                Spacer()
                
                // Days countdown pill badge
                Text(subscription.renewalBadgeText())
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
        .buttonStyle(SpringBounceButtonStyle())
        .accessibilityLabel("\(subscription.name), \(formattedDateText), renews in \(subscription.renewalBadgeText())")
    }
}
