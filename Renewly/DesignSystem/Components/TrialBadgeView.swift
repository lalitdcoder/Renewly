//
//  TrialBadgeView.swift
//  Renewly
//

import SwiftUI

struct TrialBadgeView: View {
    var text: String = "FREE TRIAL"
    var isUrgent: Bool = false
    
    var body: some View {
        HStack(spacing: 3) {
            Text("🆓")
                .font(.system(size: 10))
            Text(text)
                .font(.system(size: 11, weight: .bold))
        }
        .foregroundColor(isUrgent ? Color.renewlyAttention : Color.renewlyTrialAmberDark)
        .padding(.horizontal, 8)
        .padding(.vertical, 3)
        .background(isUrgent ? Color.renewlyAttentionBg : Color.renewlyTrialAmberBg)
        .clipShape(Capsule())
        .overlay(
            Capsule()
                .stroke(isUrgent ? Color.renewlyAttentionBorder : Color.renewlyTrialAmberBorder, lineWidth: 0.8)
        )
    }
}

struct StatusBadgeView: View {
    let status: SubscriptionStatus
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: status.iconName)
                .font(.system(size: 10, weight: .semibold))
            Text(status.displayName)
                .font(.system(size: 11, weight: .semibold))
        }
        .foregroundColor(badgeForegroundColor)
        .padding(.horizontal, 8)
        .padding(.vertical, 3)
        .background(badgeBackgroundColor)
        .clipShape(Capsule())
    }
    
    private var badgeForegroundColor: Color {
        switch status {
        case .active: return .renewlySuccess
        case .paused: return .renewlyPaused
        case .cancelled: return .renewlyAttention
        case .expired: return .renewlyTextMuted
        }
    }
    
    private var badgeBackgroundColor: Color {
        switch status {
        case .active: return .renewlySuccessBg
        case .paused: return .renewlyPausedBg
        case .cancelled: return .renewlyAttentionBg
        case .expired: return Color(hex: "F2F2F7")
        }
    }
}
