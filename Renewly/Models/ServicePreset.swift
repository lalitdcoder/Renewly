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
    let plans: [ServicePlan]
    
    init(
        id: String,
        name: String,
        iconAssetName: String? = nil,
        sfSymbolName: String,
        brandColorHex: String,
        defaultPrice: Double,
        category: SubscriptionCategory,
        defaultTrialDays: Int = 0,
        managementUrl: String? = nil,
        plans: [ServicePlan] = []
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
        self.plans = plans
    }
    
    var brandColor: Color {
        Color(hex: brandColorHex)
    }
    
    var hasPredefinedPlans: Bool {
        !plans.isEmpty
    }
    
    static func findPreset(matching name: String) -> ServicePreset? {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        return allPresets.first { preset in
            preset.name.lowercased() == trimmed ||
            trimmed.contains(preset.name.lowercased()) ||
            preset.name.lowercased().contains(trimmed)
        }
    }
    
    static func plans(for name: String) -> [ServicePlan] {
        findPreset(matching: name)?.plans ?? []
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
            managementUrl: "https://www.netflix.com/youraccount",
            plans: [
                ServicePlan(name: "Basic with Ads", subtitle: "Full HD 1080p · 2 devices · With ads", defaultPrice: 4.99),
                ServicePlan(name: "Standard", subtitle: "Full HD 1080p · 2 devices · Ad-free · Downloads", defaultPrice: 10.99),
                ServicePlan(name: "Premium", subtitle: "4K Ultra HD + HDR · Spatial Audio · 4 devices", defaultPrice: 17.99)
            ]
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
            managementUrl: "https://www.spotify.com/account",
            plans: [
                ServicePlan(name: "Individual", subtitle: "1 account · Ad-free · Offline listening", defaultPrice: 11.99),
                ServicePlan(name: "Duo", subtitle: "2 accounts for couples under one roof", defaultPrice: 16.99),
                ServicePlan(name: "Family", subtitle: "Up to 6 accounts for family members", defaultPrice: 19.99),
                ServicePlan(name: "Student", subtitle: "1 account · Discount for eligible students", defaultPrice: 5.99)
            ]
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
            managementUrl: "https://www.disneyplus.com/account",
            plans: [
                ServicePlan(name: "Standard with Ads", subtitle: "1080p Full HD · 2 concurrent streams", defaultPrice: 4.99),
                ServicePlan(name: "Standard", subtitle: "1080p Full HD · 2 streams · Downloads", defaultPrice: 7.99),
                ServicePlan(name: "Premium", subtitle: "4K UHD & HDR · Dolby Atmos · 4 streams", defaultPrice: 10.99)
            ]
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
            managementUrl: "https://www.amazon.com/mc/manage",
            plans: [
                ServicePlan(name: "Prime Monthly", subtitle: "Fast delivery, Prime Video & Music", defaultPrice: 8.99),
                ServicePlan(name: "Prime Annual", subtitle: "Save with annual billing (£7.92/mo)", defaultPrice: 95.00, billingFrequency: .yearly),
                ServicePlan(name: "Student", subtitle: "50% off for university students", defaultPrice: 4.49),
                ServicePlan(name: "Prime Video Only", subtitle: "Standalone video streaming only", defaultPrice: 5.99)
            ]
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
            managementUrl: "https://www.youtube.com/paid_memberships",
            plans: [
                ServicePlan(name: "Individual", subtitle: "Ad-free, background play, YouTube Music", defaultPrice: 11.99),
                ServicePlan(name: "Family", subtitle: "Up to 5 family members (13+) in household", defaultPrice: 19.99),
                ServicePlan(name: "Student", subtitle: "Ad-free videos & music for eligible students", defaultPrice: 6.99)
            ]
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
            managementUrl: "https://support.apple.com/HT202039",
            plans: [
                ServicePlan(name: "50 GB", subtitle: "Private Relay · Hide My Email · 1 camera", defaultPrice: 0.99, metadata: ["storage": "50 GB"]),
                ServicePlan(name: "200 GB", subtitle: "Family Sharing · Up to 5 HomeKit cameras", defaultPrice: 2.99, metadata: ["storage": "200 GB"]),
                ServicePlan(name: "2 TB", subtitle: "Family Sharing · Unlimited HomeKit cameras", defaultPrice: 8.99, metadata: ["storage": "2 TB"]),
                ServicePlan(name: "6 TB", subtitle: "Family Sharing · Unlimited HomeKit cameras", defaultPrice: 26.99, metadata: ["storage": "6 TB"]),
                ServicePlan(name: "12 TB", subtitle: "Family Sharing · Unlimited HomeKit cameras", defaultPrice: 54.99, metadata: ["storage": "12 TB"])
            ]
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
            managementUrl: "https://www.canva.com/settings/billing-and-teams",
            plans: [
                ServicePlan(name: "Pro", subtitle: "1 person · Unlimited templates, AI & brand tools", defaultPrice: 12.99),
                ServicePlan(name: "Teams", subtitle: "For team collaboration · Brand controls", defaultPrice: 24.00)
            ]
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
            managementUrl: "https://www.amazon.com/mc/manage",
            plans: [
                ServicePlan(name: "Prime Monthly", subtitle: "Fast delivery, Prime Video & Music", defaultPrice: 8.99),
                ServicePlan(name: "Prime Video Only", subtitle: "Standalone video streaming only", defaultPrice: 5.99)
            ]
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
            managementUrl: "https://support.apple.com/HT202039",
            plans: [
                ServicePlan(name: "Standard", subtitle: "Apple Original shows & movies · Family sharing", defaultPrice: 8.99),
                ServicePlan(name: "Apple One Individual", subtitle: "Apple TV+, Music, Arcade, iCloud+ 50GB", defaultPrice: 18.95),
                ServicePlan(name: "Apple One Family", subtitle: "Apple TV+, Music, Arcade, iCloud+ 200GB", defaultPrice: 24.95),
                ServicePlan(name: "Apple One Premier", subtitle: "Includes Fitness+, News+, iCloud+ 2TB", defaultPrice: 36.95)
            ]
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
            managementUrl: "https://www.disneyplus.com/account",
            plans: [
                ServicePlan(name: "Standard with Ads", subtitle: "1080p Full HD · 2 concurrent streams", defaultPrice: 4.99),
                ServicePlan(name: "Standard", subtitle: "1080p Full HD · 2 streams · Downloads", defaultPrice: 7.99),
                ServicePlan(name: "Premium", subtitle: "4K UHD & HDR · Dolby Atmos · 4 streams", defaultPrice: 10.99)
            ]
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
            managementUrl: "https://www.audible.com/account/overview",
            plans: [
                ServicePlan(name: "Standard (1 credit)", subtitle: "1 title/month + Audible Plus catalogue", defaultPrice: 7.99),
                ServicePlan(name: "Premium (2 credits)", subtitle: "2 titles/month + Audible Plus catalogue", defaultPrice: 14.99)
            ]
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
            managementUrl: "https://www.youtube.com/paid_memberships",
            plans: [
                ServicePlan(name: "Individual", subtitle: "Ad-free, background play, YouTube Music", defaultPrice: 11.99),
                ServicePlan(name: "Family", subtitle: "Up to 5 family members (13+) in household", defaultPrice: 19.99),
                ServicePlan(name: "Student", subtitle: "Ad-free videos & music for eligible students", defaultPrice: 6.99)
            ]
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
            name: "Duolingo",
            iconAssetName: "Duolingo",
            sfSymbolName: "character.book.closed.fill",
            brandColorHex: "58CC02",
            defaultPrice: 6.99,
            category: .education,
            defaultTrialDays: 14,
            managementUrl: "https://www.duolingo.com/settings/super",
            plans: [
                ServicePlan(name: "Super Individual", subtitle: "Unlimited Hearts · Ad-free · Practice hub", defaultPrice: 6.99),
                ServicePlan(name: "Super Family", subtitle: "6 accounts on one Super plan", defaultPrice: 9.99),
                ServicePlan(name: "Duolingo Max", subtitle: "Super + AI roleplay & Explain My Answer", defaultPrice: 13.99)
            ]
        ),
        ServicePreset(
            id: "chatgpt",
            name: "ChatGPT",
            iconAssetName: nil,
            sfSymbolName: "sparkles",
            brandColorHex: "10A37F",
            defaultPrice: 19.99,
            category: .productivity,
            defaultTrialDays: 0,
            managementUrl: "https://chatgpt.com/#settings/Account",
            plans: [
                ServicePlan(name: "Go", subtitle: "Essential AI assistance · GPT-4o mini", defaultPrice: 5.00),
                ServicePlan(name: "Plus", subtitle: "GPT-4o, o1, Advanced Voice, DALL-E, Canvas", defaultPrice: 19.99),
                ServicePlan(name: "Pro", subtitle: "Unlimited o1, high compute access, priority", defaultPrice: 199.00),
                ServicePlan(name: "Team", subtitle: "Per workspace member · Shared workspace", defaultPrice: 25.00)
            ]
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
            managementUrl: "https://www.notion.so/settings",
            plans: [
                ServicePlan(name: "Plus", subtitle: "Unlimited blocks & file uploads for teams", defaultPrice: 8.00),
                ServicePlan(name: "Business", subtitle: "Advanced security · Private spaces · Analytics", defaultPrice: 15.00)
            ]
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
            managementUrl: "https://account.adobe.com/plans",
            plans: [
                ServicePlan(name: "Photography (20 GB)", subtitle: "Lightroom, Lightroom Classic, Photoshop", defaultPrice: 9.98),
                ServicePlan(name: "Single App", subtitle: "1 desktop app (Photoshop, etc.) + 100GB", defaultPrice: 19.97),
                ServicePlan(name: "All Apps", subtitle: "20+ creative desktop and mobile apps", defaultPrice: 49.99),
                ServicePlan(name: "Student All Apps", subtitle: "Over 65% discount for verified students", defaultPrice: 16.24)
            ]
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
            managementUrl: "https://www.dropbox.com/account/plan",
            plans: [
                ServicePlan(name: "Plus (2 TB)", subtitle: "2,000 GB secure storage for 1 user", defaultPrice: 9.99, metadata: ["storage": "2 TB"]),
                ServicePlan(name: "Essentials (3 TB)", subtitle: "3,000 GB + advanced document tracking", defaultPrice: 18.00, metadata: ["storage": "3 TB"])
            ]
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
            managementUrl: "https://account.microsoft.com/services",
            plans: [
                ServicePlan(name: "Core", subtitle: "Online multiplayer + catalog of 25+ games", defaultPrice: 6.99),
                ServicePlan(name: "Standard", subtitle: "Hundreds of console games + multiplayer", defaultPrice: 10.99),
                ServicePlan(name: "Ultimate", subtitle: "Console, PC, Cloud Gaming + EA Play", defaultPrice: 14.99)
            ]
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
            managementUrl: "https://www.playstation.com/acct/management",
            plans: [
                ServicePlan(name: "Essential", subtitle: "Online multiplayer + monthly games", defaultPrice: 6.99),
                ServicePlan(name: "Extra", subtitle: "Game Catalogue of hundreds of PS4/PS5 games", defaultPrice: 10.99),
                ServicePlan(name: "Premium", subtitle: "Classics catalogue, cloud streaming, trials", defaultPrice: 13.49)
            ]
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
            managementUrl: "https://www.strava.com/settings/billing",
            plans: [
                ServicePlan(name: "Monthly", subtitle: "Route planning, segment leaderboards, stats", defaultPrice: 8.99),
                ServicePlan(name: "Annual", subtitle: "Billed annually (£4.58/mo equivalent)", defaultPrice: 54.99, billingFrequency: .yearly)
            ]
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
            managementUrl: nil,
            plans: [
                ServicePlan(name: "Off-Peak", subtitle: "Access during daytime off-peak hours", defaultPrice: 25.00),
                ServicePlan(name: "Standard", subtitle: "Full access to gym & equipment anytime", defaultPrice: 35.00),
                ServicePlan(name: "All-Inclusive", subtitle: "Gym + classes + spa / wellness access", defaultPrice: 50.00)
            ]
        )
    ]
}
