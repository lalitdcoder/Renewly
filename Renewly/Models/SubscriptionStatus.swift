//
//  SubscriptionStatus.swift
//  Renewly
//

import SwiftUI

enum SubscriptionStatus: String, Codable, CaseIterable {
    case active = "active"
    case paused = "paused"
    case cancelled = "cancelled"
    case expired = "expired"
    
    var displayName: String {
        switch self {
        case .active:
            return "Active"
        case .paused:
            return "Paused"
        case .cancelled:
            return "Cancelled"
        case .expired:
            return "Expired"
        }
    }
    
    var statusColor: Color {
        switch self {
        case .active:
            return .renewlySuccess
        case .paused:
            return .renewlyPaused
        case .cancelled:
            return .renewlyAttention
        case .expired:
            return .renewlyTextMuted
        }
    }
    
    var iconName: String {
        switch self {
        case .active:
            return "checkmark.circle.fill"
        case .paused:
            return "pause.circle.fill"
        case .cancelled:
            return "xmark.circle.fill"
        case .expired:
            return "clock.badge.xmark.fill"
        }
    }
}
