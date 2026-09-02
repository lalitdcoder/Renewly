//
//  SubscriptionCategory.swift
//  Renewly
//

import SwiftUI

enum SubscriptionCategory: String, Codable, CaseIterable {
    case entertainment = "Entertainment"
    case music = "Music"
    case gaming = "Gaming"
    case cloud = "Cloud & Storage"
    case productivity = "Productivity"
    case utilities = "Utilities"
    case healthAndFitness = "Health & Fitness"
    case education = "Education"
    case lifestyle = "Lifestyle"
    case finance = "Finance"
    case other = "Other"
    
    var iconName: String {
        switch self {
        case .entertainment:
            return "film.fill"
        case .music:
            return "music.note"
        case .gaming:
            return "gamecontroller.fill"
        case .cloud:
            return "cloud.fill"
        case .productivity:
            return "doc.text.fill"
        case .utilities:
            return "wrench.and.screwdriver.fill"
        case .healthAndFitness:
            return "heart.fill"
        case .education:
            return "book.fill"
        case .lifestyle:
            return "cup.and.saucer.fill"
        case .finance:
            return "creditcard.fill"
        case .other:
            return "square.grid.2x2.fill"
        }
    }
    
    var color: Color {
        CategoryManager.shared.color(for: self.rawValue)
    }
}
