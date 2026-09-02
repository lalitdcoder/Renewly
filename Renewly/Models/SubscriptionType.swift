//
//  SubscriptionType.swift
//  Renewly
//

import Foundation

enum SubscriptionType: String, Codable, CaseIterable {
    case subscription = "subscription"
    case trial = "trial"
    
    var displayName: String {
        switch self {
        case .subscription:
            return "Subscription"
        case .trial:
            return "Free Trial"
        }
    }
}
