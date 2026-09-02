//
//  BillingFrequency.swift
//  Renewly
//

import Foundation

enum BillingFrequency: Codable, Equatable, Hashable {
    case monthly
    case yearly
    case weekly
    case customDays(Int)
    
    var rawString: String {
        switch self {
        case .monthly:
            return "Monthly"
        case .yearly:
            return "Yearly"
        case .weekly:
            return "Weekly"
        case .customDays(let days):
            return "Every \(days) days"
        }
    }
    
    var suffixText: String {
        switch self {
        case .monthly:
            return "month"
        case .yearly:
            return "year"
        case .weekly:
            return "week"
        case .customDays(let days):
            return "\(days) days"
        }
    }
    
    var shortLabel: String {
        switch self {
        case .monthly:
            return "/ month"
        case .yearly:
            return "/ year"
        case .weekly:
            return "/ week"
        case .customDays(let days):
            return "/ \(days)d"
        }
    }
    
    // Calculates monthly multiplier for spend math
    var monthlyFactor: Double {
        switch self {
        case .monthly:
            return 1.0
        case .yearly:
            return 1.0 / 12.0
        case .weekly:
            return 52.0 / 12.0
        case .customDays(let days):
            guard days > 0 else { return 1.0 }
            return 30.4375 / Double(days)
        }
    }
    
    // Calculates yearly multiplier for spend math
    var yearlyFactor: Double {
        switch self {
        case .monthly:
            return 12.0
        case .yearly:
            return 1.0
        case .weekly:
            return 52.0
        case .customDays(let days):
            guard days > 0 else { return 12.0 }
            return 365.25 / Double(days)
        }
    }
}
