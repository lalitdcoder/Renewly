//
//  SampleDataLoader.swift
//  Renewly
//

import Foundation
import SwiftData

struct SampleDataLoader {
    static func createSampleSubscriptions(referenceDate: Date = Date()) -> [SubscriptionModel] {
        let calendar = Calendar.current
        
        let netflixRenewal = calendar.date(byAdding: .day, value: 3, to: referenceDate)
        let spotifyRenewal = calendar.date(byAdding: .day, value: 11, to: referenceDate)
        let icloudRenewal = calendar.date(byAdding: .day, value: 17, to: referenceDate)
        let disneyRenewal = calendar.date(byAdding: .day, value: 24, to: referenceDate)
        let primeRenewal = calendar.date(byAdding: .day, value: 27, to: referenceDate)
        let duolingoRenewal = calendar.date(byAdding: .day, value: 29, to: referenceDate)
        let storageRenewal = calendar.date(byAdding: .day, value: 30, to: referenceDate)
        let youtubeRenewal = calendar.date(byAdding: .day, value: 32, to: referenceDate)
        let canvaTrialEnd = calendar.date(byAdding: .day, value: 2, to: referenceDate)
        
        return [
            SubscriptionModel(
                name: "Netflix",
                iconAssetName: "Netflix",
                sfSymbolName: "play.rectangle.fill",
                brandColorHex: "E50914",
                category: .entertainment,
                type: .subscription,
                price: 17.99,
                currency: "£",
                billingFrequency: .monthly,
                startDate: calendar.date(byAdding: .month, value: -8, to: referenceDate),
                nextRenewalDate: netflixRenewal,
                hasUnknownRenewalDate: false,
                status: .active,
                reminderDays: [7, 3, 1],
                notes: "Family plan",
                managementUrl: "https://www.netflix.com/youraccount"
            ),
            SubscriptionModel(
                name: "Spotify",
                iconAssetName: "Spotify",
                sfSymbolName: "music.note",
                brandColorHex: "1DB954",
                category: .music,
                type: .subscription,
                price: 11.99,
                currency: "£",
                billingFrequency: .monthly,
                startDate: calendar.date(byAdding: .month, value: -12, to: referenceDate),
                nextRenewalDate: spotifyRenewal,
                hasUnknownRenewalDate: false,
                status: .active,
                reminderDays: [7],
                notes: "Individual Premium",
                managementUrl: "https://www.spotify.com/account"
            ),
            SubscriptionModel(
                name: "iCloud+",
                iconAssetName: "iCloud",
                sfSymbolName: "icloud.fill",
                brandColorHex: "3388FF",
                category: .cloud,
                type: .subscription,
                price: 2.99,
                currency: "£",
                billingFrequency: .monthly,
                startDate: calendar.date(byAdding: .month, value: -24, to: referenceDate),
                nextRenewalDate: icloudRenewal,
                hasUnknownRenewalDate: false,
                status: .active,
                reminderDays: [7],
                notes: "200 GB Storage",
                managementUrl: "https://support.apple.com/HT202039"
            ),
            SubscriptionModel(
                name: "Disney+",
                iconAssetName: "DisneyPlus",
                sfSymbolName: "sparkles.tv.fill",
                brandColorHex: "113CCF",
                category: .entertainment,
                type: .subscription,
                price: 7.99,
                currency: "£",
                billingFrequency: .monthly,
                startDate: calendar.date(byAdding: .month, value: -3, to: referenceDate),
                nextRenewalDate: disneyRenewal,
                hasUnknownRenewalDate: false,
                status: .active,
                reminderDays: [7],
                notes: "Standard with Ads",
                managementUrl: "https://www.disneyplus.com/account"
            ),
            SubscriptionModel(
                name: "Amazon Prime Video",
                iconAssetName: "PrimeVideo",
                sfSymbolName: "cart.fill",
                brandColorHex: "00A8E1",
                category: .entertainment,
                type: .subscription,
                price: 8.99,
                currency: "£",
                billingFrequency: .monthly,
                startDate: calendar.date(byAdding: .month, value: -4, to: referenceDate),
                nextRenewalDate: primeRenewal,
                hasUnknownRenewalDate: false,
                status: .active,
                reminderDays: [7],
                notes: "Monthly video streaming",
                managementUrl: "https://www.amazon.com/mc/manage"
            ),
            SubscriptionModel(
                name: "Duolingo Plus",
                iconAssetName: "Duolingo",
                sfSymbolName: "character.book.closed.fill",
                brandColorHex: "58CC02",
                category: .education,
                type: .subscription,
                price: 6.99,
                currency: "£",
                billingFrequency: .monthly,
                startDate: calendar.date(byAdding: .month, value: -2, to: referenceDate),
                nextRenewalDate: duolingoRenewal,
                hasUnknownRenewalDate: false,
                status: .active,
                reminderDays: [7],
                notes: "Spanish learning",
                managementUrl: "https://www.duolingo.com/settings/super"
            ),
            SubscriptionModel(
                name: "Dropbox Plus",
                iconAssetName: nil,
                sfSymbolName: "archivebox.fill",
                brandColorHex: "0061FF",
                category: .cloud,
                type: .subscription,
                price: 7.00,
                currency: "£",
                billingFrequency: .monthly,
                startDate: calendar.date(byAdding: .month, value: -1, to: referenceDate),
                nextRenewalDate: storageRenewal,
                hasUnknownRenewalDate: false,
                status: .active,
                reminderDays: [7],
                notes: "Backup drive",
                managementUrl: "https://www.dropbox.com/account/plan"
            ),
            SubscriptionModel(
                name: "YouTube Premium",
                iconAssetName: nil,
                sfSymbolName: "play.circle.fill",
                brandColorHex: "FF0000",
                category: .entertainment,
                type: .subscription,
                price: 11.99,
                currency: "£",
                billingFrequency: .monthly,
                startDate: calendar.date(byAdding: .month, value: -8, to: referenceDate),
                nextRenewalDate: youtubeRenewal,
                hasUnknownRenewalDate: false,
                status: .paused,
                reminderDays: [7],
                notes: "Paused for summer",
                managementUrl: "https://www.youtube.com/paid_memberships"
            ),
            SubscriptionModel(
                name: "Canva",
                iconAssetName: nil,
                sfSymbolName: "paintbrush.pointed.fill",
                brandColorHex: "00C4CC",
                category: .productivity,
                type: .trial,
                price: 0.0,
                currency: "£",
                billingFrequency: .monthly,
                startDate: calendar.date(byAdding: .day, value: -12, to: referenceDate),
                nextRenewalDate: canvaTrialEnd,
                hasUnknownRenewalDate: false,
                trialDurationDays: 14,
                priceAfterTrial: 12.99,
                status: .active,
                reminderDays: [7, 1],
                notes: "Pro 14-day free trial",
                managementUrl: "https://www.canva.com/settings/billing-and-teams"
            )
        ]
    }
    
    @MainActor
    static func seedIfNeeded(modelContext: ModelContext) {
        let descriptor = FetchDescriptor<SubscriptionModel>()
        let count = (try? modelContext.fetchCount(descriptor)) ?? 0
        if count == 0 {
            let samples = createSampleSubscriptions()
            for item in samples {
                modelContext.insert(item)
                NotificationManager.shared.scheduleReminders(for: item)
            }
            try? modelContext.save()
        }
    }
    
    @MainActor
    static func resetToSampleData(modelContext: ModelContext) {
        let descriptor = FetchDescriptor<SubscriptionModel>()
        if let existing = try? modelContext.fetch(descriptor) {
            for item in existing {
                NotificationManager.shared.cancelReminders(for: item)
                modelContext.delete(item)
            }
        }
        let samples = createSampleSubscriptions()
        for item in samples {
            modelContext.insert(item)
            NotificationManager.shared.scheduleReminders(for: item)
        }
        try? modelContext.save()
    }
}
