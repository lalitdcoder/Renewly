//
//  Colors.swift
//  Renewly
//

import SwiftUI

extension Color {
    // Brand Purples
    static let renewlyPrimary = Color(hex: "6354EC")
    static let renewlyPrimaryDark = Color(hex: "4F3ED4")
    static let renewlyPrimaryLight = Color(hex: "ECE9FE")
    static let renewlyPrimaryUltraLight = Color(hex: "F7F5FF")
    
    // Backgrounds & Surfaces
    static let renewlyBackground = Color(hex: "F8F9FA")
    static let renewlyCardBackground = Color.white
    static let renewlyCardBorder = Color(hex: "EFEFF2")
    static let renewlyCardBorderHover = Color(hex: "E2E2EA")
    static let renewlyDivider = Color(hex: "F0F0F4")
    
    // Typography Colors
    static let renewlyTextPrimary = Color(hex: "17171B")
    static let renewlyTextSecondary = Color(hex: "7C7C88")
    static let renewlyTextMuted = Color(hex: "A0A0AB")
    
    // Status & Accent Colors
    static let renewlyAttention = Color(hex: "FF5A36")
    static let renewlyAttentionBg = Color(hex: "FFF1EE")
    static let renewlyAttentionBorder = Color(hex: "FEDCD5")
    
    // Trial Brand Accent (Calm Warm Amber / Sunset)
    static let renewlyTrialAmber = Color(hex: "F58220")
    static let renewlyTrialAmberDark = Color(hex: "D9680C")
    static let renewlyTrialAmberBg = Color(hex: "FFF5EB")
    static let renewlyTrialAmberBorder = Color(hex: "FFE3C6")
    
    static let renewlySuccess = Color(hex: "27AE60")
    static let renewlySuccessBg = Color(hex: "E8F8F0")
    static let renewlyWarning = Color(hex: "FF9500")
    static let renewlyWarningBg = Color(hex: "FFF6E8")
    static let renewlyPaused = Color(hex: "F5A623")
    static let renewlyPausedBg = Color(hex: "FFF9EE")
    
    // Gradients
    static let renewlySpendingGradient = LinearGradient(
        colors: [Color(hex: "5A48EB"), Color(hex: "7C68F9")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let renewlyButtonGradient = LinearGradient(
        colors: [Color(hex: "6354EC"), Color(hex: "5745E6")],
        startPoint: .top,
        endPoint: .bottom
    )
    
    static let renewlyTrialGradient = LinearGradient(
        colors: [Color(hex: "FF9900"), Color(hex: "FF5E3A")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    // Hex Initializer
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
