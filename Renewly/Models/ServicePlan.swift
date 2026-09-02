//
//  ServicePlan.swift
//  Renewly
//

import Foundation

struct ServicePlan: Identifiable, Hashable, Codable {
    let id: String
    let name: String
    let subtitle: String?
    let defaultPrice: Double
    let billingFrequency: BillingFrequency
    let metadata: [String: String]?
    
    init(
        id: String = UUID().uuidString,
        name: String,
        subtitle: String? = nil,
        defaultPrice: Double,
        billingFrequency: BillingFrequency = .monthly,
        metadata: [String: String]? = nil
    ) {
        self.id = id
        self.name = name
        self.subtitle = subtitle
        self.defaultPrice = defaultPrice
        self.billingFrequency = billingFrequency
        self.metadata = metadata
    }
}
