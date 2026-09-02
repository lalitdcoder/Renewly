//
//  ServicePreset.swift
//  Renewly
//

import SwiftUI

struct ServicePreset: Identifiable, Hashable {
    let id: String
    let name: String
    let iconAssetName: String?
    let sfSymbolName: String
    let brandColorHex: String
    let defaultPrice: Double
    let category: SubscriptionCategory
    let defaultTrialDays: Int
    let managementUrl: String?
    
    init(
        id: String,
        name: String,
        iconAssetName: String? = nil,
        sfSymbolName: String,
        brandColorHex: String,
        defaultPrice: Double,
        category: SubscriptionCategory,
        defaultTrialDays: Int = 0,
        managementUrl: String? = nil
    ) {
        self.id = id
        self.name = name
        self.iconAssetName = iconAssetName
        self.sfSymbolName = sfSymbolName
        self.brandColorHex = brandColorHex
        self.defaultPrice = defaultPrice
        self.category = category
        self.defaultTrialDays = defaultTrialDays
        self.managementUrl = managementUrl
    }
    
    var brandColor: Color {
        Color(hex: brandColorHex)
    }
    
    static let popularSubscriptions: [ServicePreset] = [
        ServicePreset(
            id: "netflix",
            name: "Netflix",
            iconAssetName: "Netflix",
            sfSymbolName: "play.rectangle.fill",
            brandColorHex: "E50914",
            defaultPrice: 17.99,
            category: .entertainment,
            defaultTrialDays: 7,
            managementUrl: "https://www.netflix.com/youraccount"
        ),
        ServicePreset(
            id: "spotify",
            name: "Spotify",
            iconAssetName: "Spotify",
            sfSymbolName: "music.note",
            brandColorHex: "1DB954",
            defaultPrice: 11.99,
            category: .music,
            defaultTrialDays: 30,
            managementUrl: "https://www.spotify.com/account"
        ),
        ServicePreset(
            id: "disneyplus",
            name: "Disney+",
            iconAssetName: "DisneyPlus",
            sfSymbolName: "sparkles.tv.fill",
            brandColorHex: "113CCF",
            defaultPrice: 7.99,
            category: .entertainment,
            defaultTrialDays: 7,
            managementUrl: "https://www.disneyplus.com/account"
        ),
        ServicePreset(
            id: "primevideo",
            name: "Amazon Prime",
            iconAssetName: "PrimeVideo",
            sfSymbolName: "cart.fill",
            brandColorHex: "00A8E1",
            defaultPrice: 8.99,
            category: .entertainment,
            defaultTrialDays: 30,
            managementUrl: "https://www.amazon.com/mc/manage"
        ),
        ServicePreset(
            id: "youtubepremium",
            name: "YouTube Premium",
            iconAssetName: nil,
            sfSymbolName: "play.circle.fill",
            brandColorHex: "FF0000",
            defaultPrice: 11.99,
            category: .entertainment,
            defaultTrialDays: 30,
            managementUrl: "https://www.youtube.com/paid_memberships"
        ),
        ServicePreset(
            id: "icloud",
            name: "iCloud+",
            iconAssetName: "iCloud",
            sfSymbolName: "icloud.fill",
            brandColorHex: "3388FF",
            defaultPrice: 2.99,
            category: .cloud,
            defaultTrialDays: 30,
            managementUrl: "https://support.apple.com/HT202039"
        )
    ]
    
    static let popularTrials: [ServicePreset] = [
        ServicePreset(
            id: "canva",
            name: "Canva",
            iconAssetName: nil,
            sfSymbolName: "paintbrush.pointed.fill",
            brandColorHex: "00C4CC",
            defaultPrice: 12.99,
            category: .productivity,
            defaultTrialDays: 14,
            managementUrl: "https://www.canva.com/settings/billing-and-teams"
        ),
        ServicePreset(
            id: "primevideo",
            name: "Amazon Prime Video",
            iconAssetName: "PrimeVideo",
            sfSymbolName: "cart.fill",
            brandColorHex: "00A8E1",
            defaultPrice: 8.99,
            category: .entertainment,
            defaultTrialDays: 30,
            managementUrl: "https://www.amazon.com/mc/manage"
        ),
        ServicePreset(
            id: "appletv",
            name: "Apple TV+",
            iconAssetName: nil,
            sfSymbolName: "appletvremote.gen4.fill",
            brandColorHex: "000000",
            defaultPrice: 8.99,
            category: .entertainment,
            defaultTrialDays: 7,
            managementUrl: "https://support.apple.com/HT202039"
        ),
        ServicePreset(
            id: "disneyplus",
            name: "Disney+",
            iconAssetName: "DisneyPlus",
            sfSymbolName: "sparkles.tv.fill",
            brandColorHex: "113CCF",
            defaultPrice: 7.99,
            category: .entertainment,
            defaultTrialDays: 7,
            managementUrl: "https://www.disneyplus.com/account"
        ),
        ServicePreset(
            id: "audible",
            name: "Audible",
            iconAssetName: nil,
            sfSymbolName: "headphones",
            brandColorHex: "F7991C",
            defaultPrice: 7.99,
            category: .entertainment,
            defaultTrialDays: 30,
            managementUrl: "https://www.audible.com/account/overview"
        ),
        ServicePreset(
            id: "youtubepremium",
            name: "YouTube Premium",
            iconAssetName: nil,
            sfSymbolName: "play.circle.fill",
            brandColorHex: "FF0000",
            defaultPrice: 11.99,
            category: .entertainment,
            defaultTrialDays: 30,
            managementUrl: "https://www.youtube.com/paid_memberships"
        )
    ]
    
    static let allPresets: [ServicePreset] = [
        popularSubscriptions[0], // Netflix
        popularSubscriptions[1], // Spotify
        popularSubscriptions[2], // Disney+
        popularSubscriptions[3], // Prime
        popularSubscriptions[4], // YouTube
        popularSubscriptions[5], // iCloud
        popularTrials[0],        // Canva
        popularTrials[2],        // Apple TV+
        popularTrials[4],        // Audible
        ServicePreset(
            id: "duolingo",
            name: "Duolingo Plus",
            iconAssetName: "Duolingo",
            sfSymbolName: "character.book.closed.fill",
            brandColorHex: "58CC02",
            defaultPrice: 6.99,
            category: .education,
            defaultTrialDays: 14,
            managementUrl: "https://www.duolingo.com/settings/super"
        ),
        ServicePreset(
            id: "chatgpt",
            name: "ChatGPT Plus",
            iconAssetName: nil,
            sfSymbolName: "sparkles",
            brandColorHex: "10A37F",
            defaultPrice: 19.99,
            category: .productivity,
            defaultTrialDays: 0,
            managementUrl: "https://chatgpt.com/#settings/Account"
        ),
        ServicePreset(
            id: "notion",
            name: "Notion",
            iconAssetName: nil,
            sfSymbolName: "note.text",
            brandColorHex: "000000",
            defaultPrice: 8.00,
            category: .productivity,
            defaultTrialDays: 14,
            managementUrl: "https://www.notion.so/settings"
        ),
        ServicePreset(
            id: "adobe",
            name: "Adobe Creative Cloud",
            iconAssetName: nil,
            sfSymbolName: "camera.filters",
            brandColorHex: "FF0000",
            defaultPrice: 49.99,
            category: .productivity,
            defaultTrialDays: 7,
            managementUrl: "https://account.adobe.com/plans"
        ),
        ServicePreset(
            id: "dropbox",
            name: "Dropbox",
            iconAssetName: nil,
            sfSymbolName: "archivebox.fill",
            brandColorHex: "0061FF",
            defaultPrice: 9.99,
            category: .cloud,
            defaultTrialDays: 30,
            managementUrl: "https://www.dropbox.com/account/plan"
        ),
        ServicePreset(
            id: "xboxgamepass",
            name: "Xbox Game Pass",
            iconAssetName: nil,
            sfSymbolName: "gamecontroller.fill",
            brandColorHex: "107C10",
            defaultPrice: 12.99,
            category: .gaming,
            defaultTrialDays: 14,
            managementUrl: "https://account.microsoft.com/services"
        ),
        ServicePreset(
            id: "playstationplus",
            name: "PlayStation Plus",
            iconAssetName: nil,
            sfSymbolName: "gamecontroller.fill",
            brandColorHex: "003791",
            defaultPrice: 6.99,
            category: .gaming,
            defaultTrialDays: 7,
            managementUrl: "https://www.playstation.com/acct/management"
        ),
        ServicePreset(
            id: "strava",
            name: "Strava",
            iconAssetName: nil,
            sfSymbolName: "figure.run",
            brandColorHex: "FC4C02",
            defaultPrice: 8.99,
            category: .healthAndFitness,
            defaultTrialDays: 30,
            managementUrl: "https://www.strava.com/settings/billing"
        ),
        ServicePreset(
            id: "gym",
            name: "Gym Membership",
            iconAssetName: nil,
            sfSymbolName: "dumbbell.fill",
            brandColorHex: "34C759",
            defaultPrice: 35.00,
            category: .healthAndFitness,
            defaultTrialDays: 0,
            managementUrl: nil
        )
    ]
}
