//
//  DataExportManager.swift
//  Renewly
//

import Foundation
import SwiftData

struct SubscriptionExportDTO: Codable {
    let id: String
    let name: String
    let iconAssetName: String?
    let sfSymbolName: String
    let brandColorHex: String
    let category: String
    let type: String
    let price: Double
    let currency: String
    let billingFrequencyType: String
    let billingCustomDays: Int
    let nextRenewalDate: Date?
    let hasUnknownRenewalDate: Bool
    let trialDurationDays: Int?
    let priceAfterTrial: Double?
    let status: String
    let reminderDays: [Int]
    let notes: String
    let createdAt: Date
}

enum DataExportManager {
    static func exportToJSON(subscriptions: [SubscriptionModel]) -> Data? {
        let dtos = subscriptions.map { sub in
            SubscriptionExportDTO(
                id: sub.id.uuidString,
                name: sub.name,
                iconAssetName: sub.iconAssetName,
                sfSymbolName: sub.sfSymbolName,
                brandColorHex: sub.brandColorHex,
                category: sub.categoryRaw,
                type: sub.typeRaw,
                price: sub.price,
                currency: sub.currency,
                billingFrequencyType: sub.billingFrequencyType,
                billingCustomDays: sub.billingCustomDays,
                nextRenewalDate: sub.nextRenewalDate,
                hasUnknownRenewalDate: sub.hasUnknownRenewalDate,
                trialDurationDays: sub.trialDurationDays,
                priceAfterTrial: sub.priceAfterTrial,
                status: sub.statusRaw,
                reminderDays: sub.reminderDays,
                notes: sub.notes,
                createdAt: sub.createdAt
            )
        }
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        encoder.dateEncodingStrategy = .iso8601
        return try? encoder.encode(dtos)
    }
    
    static func exportToCSV(subscriptions: [SubscriptionModel]) -> String {
        var csv = "Name,Type,Price,Currency,Frequency,Category,Status,Next Renewal,Notes\n"
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        
        for sub in subscriptions {
            let renewalStr = sub.nextRenewalDate.map { formatter.string(from: $0) } ?? "Unknown"
            let escapedNotes = sub.notes.replacingOccurrences(of: "\"", with: "\"\"")
            let line = "\"\(sub.name)\",\"\(sub.typeRaw)\",\(sub.price),\"\(sub.currency)\",\"\(sub.billingFrequencyType)\",\"\(sub.categoryRaw)\",\"\(sub.statusRaw)\",\"\(renewalStr)\",\"\(escapedNotes)\"\n"
            csv.append(line)
        }
        return csv
    }
}
