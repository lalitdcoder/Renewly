//
//  SubscriptionOverviewCard.swift
//  Renewly
//

import SwiftUI

struct SubscriptionOverviewCard: View {
    let activeCount: Int
    let trialCount: Int
    let pausedCount: Int
    let cancelledCount: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Subscription overview")
                .font(.system(size: 15, weight: .bold))
                .foregroundColor(.renewlyTextPrimary)
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                OverviewTile(
                    count: activeCount,
                    title: "Active",
                    icon: "checkmark.circle.fill",
                    color: .renewlySuccess,
                    bgColor: .renewlySuccessBg
                )
                
                OverviewTile(
                    count: trialCount,
                    title: "Free Trials",
                    icon: "gift.fill",
                    color: Color.renewlyTrialAmber,
                    bgColor: Color.renewlyTrialAmberBg
                )
                
                OverviewTile(
                    count: pausedCount,
                    title: "Paused",
                    icon: "pause.circle.fill",
                    color: .renewlyPaused,
                    bgColor: .renewlyPausedBg
                )
                
                OverviewTile(
                    count: cancelledCount,
                    title: "Cancelled",
                    icon: "xmark.circle.fill",
                    color: .renewlyAttention,
                    bgColor: .renewlyAttentionBg
                )
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

struct OverviewTile: View {
    let count: Int
    let title: String
    let icon: String
    let color: Color
    let bgColor: Color
    
    var body: some View {
        HStack(spacing: 10) {
            ZStack {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(bgColor)
                    .frame(width: 34, height: 34)
                
                Image(systemName: icon)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(color)
            }
            
            VStack(alignment: .leading, spacing: 1) {
                Text("\(count)")
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundColor(.renewlyTextPrimary)
                Text(title)
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(.renewlyTextSecondary)
            }
            
            Spacer()
        }
        .padding(10)
        .background(Color(hex: "F9F9FB"))
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}
