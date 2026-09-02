//
//  SubscriptionReviewCard.swift
//  Renewly
//

import SwiftUI

struct SubscriptionReviewCard: View {
    let subscription: SubscriptionModel
    let onKeep: () -> Void
    let onReview: () -> Void
    
    private var monthsTracked: Int {
        subscription.trackingDurationInMonths()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack(spacing: 6) {
                Image(systemName: "sparkles")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.renewlyPrimary)
                
                Text("Worth reviewing?")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.renewlyTextSecondary)
                    .textCase(.uppercase)
                
                Spacer()
            }
            
            // Service Info Row
            HStack(spacing: 12) {
                ServiceIconView(
                    name: subscription.name,
                    iconAssetName: subscription.iconAssetName,
                    sfSymbolName: subscription.sfSymbolName,
                    brandColorHex: subscription.brandColorHex,
                    size: 42
                )
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(subscription.name)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.renewlyTextPrimary)
                    
                    Text("You've been tracking this subscription for \(monthsTracked) month\(monthsTracked == 1 ? "" : "s").")
                        .font(.system(size: 13, weight: .regular))
                        .foregroundColor(.renewlyTextSecondary)
                }
                
                Spacer()
                
                Text(String(format: "%@%.2f %@", subscription.currency, subscription.price, subscription.billingFrequency.shortLabel))
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .foregroundColor(.renewlyTextPrimary)
            }
            
            // Action Buttons
            HStack(spacing: 10) {
                Button(action: {
                    let impact = UIImpactFeedbackGenerator(style: .light)
                    impact.impactOccurred()
                    onKeep()
                }) {
                    Text("Keep subscription")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.renewlyTextPrimary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 9)
                        .background(Color(hex: "F2F2F6"))
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                }
                
                Button(action: {
                    let impact = UIImpactFeedbackGenerator(style: .light)
                    impact.impactOccurred()
                    onReview()
                }) {
                    Text("Review")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 9)
                        .background(Color.renewlyPrimary)
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                }
            }
            .padding(.top, 2)
        }
        .padding(16)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(Color.renewlyCardBorder, lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.02), radius: 4, y: 1)
    }
}
