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
            defaultTrialDays: 7
        ),
        ServicePreset(
            id: "spotify",
            name: "Spotify",
            iconAssetName: "Spotify",
            sfSymbolName: "music.note",
            brandColorHex: "1DB954",
            defaultPrice: 11.99,
            category: .music,
            defaultTrialDays: 30
        ),
        ServicePreset(
            id: "disneyplus",
            name: "Disney+",
            iconAssetName: "DisneyPlus",
            sfSymbolName: "sparkles.tv.fill",
            brandColorHex: "113CCF",
            defaultPrice: 7.99,
            category: .entertainment,
            defaultTrialDays: 7
        ),
        ServicePreset(
            id: "primevideo",
            name: "Amazon Prime Video",
            iconAssetName: "PrimeVideo",
            sfSymbolName: "cart.fill",
            brandColorHex: "00A8E1",
            defaultPrice: 8.99,
            category: .entertainment,
            defaultTrialDays: 30
        ),
        ServicePreset(
            id: "youtubepremium",
            name: "YouTube Premium",
            iconAssetName: nil,
            sfSymbolName: "play.circle.fill",
            brandColorHex: "FF0000",
            defaultPrice: 11.99,
            category: .entertainment,
            defaultTrialDays: 30
        ),
        ServicePreset(
            id: "icloud",
            name: "iCloud",
            iconAssetName: "iCloud",
            sfSymbolName: "icloud.fill",
            brandColorHex: "3388FF",
            defaultPrice: 2.99,
            category: .cloud,
            defaultTrialDays: 30
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
            defaultTrialDays: 14
        ),
        ServicePreset(
            id: "primevideo",
            name: "Amazon Prime Video",
            iconAssetName: "PrimeVideo",
            sfSymbolName: "cart.fill",
            brandColorHex: "00A8E1",
            defaultPrice: 8.99,
            category: .entertainment,
            defaultTrialDays: 30
        ),
        ServicePreset(
            id: "appletv",
            name: "Apple TV+",
            iconAssetName: nil,
            sfSymbolName: "appletvremote.gen4.fill",
            brandColorHex: "000000",
            defaultPrice: 8.99,
            category: .entertainment,
            defaultTrialDays: 7
        ),
        ServicePreset(
            id: "disneyplus",
            name: "Disney+",
            iconAssetName: "DisneyPlus",
            sfSymbolName: "sparkles.tv.fill",
            brandColorHex: "113CCF",
            defaultPrice: 7.99,
            category: .entertainment,
            defaultTrialDays: 7
        ),
        ServicePreset(
            id: "audible",
            name: "Audible",
            iconAssetName: nil,
            sfSymbolName: "headphones",
            brandColorHex: "F7991C",
            defaultPrice: 7.99,
            category: .entertainment,
            defaultTrialDays: 30
        ),
        ServicePreset(
            id: "youtubepremium",
            name: "YouTube Premium",
            iconAssetName: nil,
            sfSymbolName: "play.circle.fill",
            brandColorHex: "FF0000",
            defaultPrice: 11.99,
            category: .entertainment,
            defaultTrialDays: 30
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
            defaultTrialDays: 14
        ),
        ServicePreset(
            id: "chatgpt",
            name: "ChatGPT Plus",
            iconAssetName: nil,
            sfSymbolName: "sparkles",
            brandColorHex: "10A37F",
            defaultPrice: 19.99,
            category: .productivity,
            defaultTrialDays: 0
        ),
        ServicePreset(
            id: "notion",
            name: "Notion",
            iconAssetName: nil,
            sfSymbolName: "note.text",
            brandColorHex: "000000",
            defaultPrice: 8.00,
            category: .productivity,
            defaultTrialDays: 14
        ),
        ServicePreset(
            id: "adobe",
            name: "Adobe Creative Cloud",
            iconAssetName: nil,
            sfSymbolName: "camera.filters",
            brandColorHex: "FF0000",
            defaultPrice: 49.99,
            category: .productivity,
            defaultTrialDays: 7
        ),
        ServicePreset(
            id: "dropbox",
            name: "Dropbox",
            iconAssetName: nil,
            sfSymbolName: "archivebox.fill",
            brandColorHex: "0061FF",
            defaultPrice: 9.99,
            category: .cloud,
            defaultTrialDays: 30
        ),
        ServicePreset(
            id: "strava",
            name: "Strava",
            iconAssetName: nil,
            sfSymbolName: "figure.run",
            brandColorHex: "FC4C02",
            defaultPrice: 8.99,
            category: .healthAndFitness,
            defaultTrialDays: 30
        ),
        ServicePreset(
            id: "gym",
            name: "Gym Membership",
            iconAssetName: nil,
            sfSymbolName: "dumbbell.fill",
            brandColorHex: "34C759",
            defaultPrice: 35.00,
            category: .healthAndFitness,
            defaultTrialDays: 0
        )
    ]
}
