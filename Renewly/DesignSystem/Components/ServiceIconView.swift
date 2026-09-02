//
//  ServiceIconView.swift
//  Renewly
//

import SwiftUI

struct ServiceIconView: View {
    let name: String
    var iconAssetName: String? = nil
    var sfSymbolName: String = "creditcard.fill"
    var brandColorHex: String = "6354EC"
    var size: CGFloat = 44
    var cornerRadius: CGFloat? = nil
    
    private var computedCornerRadius: CGFloat {
        cornerRadius ?? (size * 0.28)
    }
    
    var body: some View {
        Group {
            if let asset = iconAssetName, UIImage(named: asset) != nil {
                Image(asset)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size, height: size)
                    .clipShape(RoundedRectangle(cornerRadius: computedCornerRadius, style: .continuous))
            } else if let asset = mappedAssetName(for: name), UIImage(named: asset) != nil {
                Image(asset)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size, height: size)
                    .clipShape(RoundedRectangle(cornerRadius: computedCornerRadius, style: .continuous))
            } else {
                // Fallback styled tile with authentic branding
                let brand = brandDetails(for: name)
                ZStack {
                    RoundedRectangle(cornerRadius: computedCornerRadius, style: .continuous)
                        .fill(brand.color)
                    
                    if let textLogo = brand.textLogo {
                        Text(textLogo)
                            .font(.system(size: size * 0.38, weight: .bold, design: .rounded))
                            .foregroundColor(brand.foregroundColor)
                    } else {
                        Image(systemName: brand.symbol)
                            .font(.system(size: size * 0.44, weight: .semibold))
                            .foregroundColor(brand.foregroundColor)
                    }
                }
                .frame(width: size, height: size)
            }
        }
        .overlay(
            RoundedRectangle(cornerRadius: computedCornerRadius, style: .continuous)
                .stroke(Color.black.opacity(0.06), lineWidth: 0.8)
        )
        .shadow(color: Color.black.opacity(0.04), radius: 3, y: 1)
    }
    
    private func mappedAssetName(for name: String) -> String? {
        let lower = name.lowercased()
        if lower.contains("netflix") { return "Netflix" }
        if lower.contains("spotify") { return "Spotify" }
        if lower.contains("disney") { return "DisneyPlus" }
        if lower.contains("prime") || lower.contains("amazon") { return "PrimeVideo" }
        if lower.contains("icloud") || lower.contains("apple cloud") { return "iCloud" }
        if lower.contains("duolingo") { return "Duolingo" }
        return nil
    }
    
    private func brandDetails(for name: String) -> (color: Color, symbol: String, foregroundColor: Color, textLogo: String?) {
        let lower = name.lowercased()
        if lower.contains("canva") {
            return (Color(hex: "00C4CC"), "paintbrush.pointed.fill", .white, "C")
        } else if lower.contains("apple") || lower.contains("apple tv") {
            return (Color(hex: "1C1C1E"), "apple.logo", .white, nil)
        } else if lower.contains("youtube") {
            return (Color(hex: "FF0000"), "play.fill", .white, nil)
        } else if lower.contains("audible") {
            return (Color(hex: "F7991C"), "headphones", .white, nil)
        } else if lower.contains("chatgpt") || lower.contains("openai") {
            return (Color(hex: "10A37F"), "sparkles", .white, nil)
        } else if lower.contains("notion") {
            return (Color(hex: "111111"), "note.text", .white, "N")
        } else if lower.contains("adobe") {
            return (Color(hex: "FA0F00"), "camera.filters", .white, "Ai")
        } else if lower.contains("dropbox") {
            return (Color(hex: "0061FF"), "archivebox.fill", .white, nil)
        } else if lower.contains("strava") {
            return (Color(hex: "FC4C02"), "figure.run", .white, nil)
        } else if lower.contains("gym") || lower.contains("fitness") {
            return (Color(hex: "27AE60"), "dumbbell.fill", .white, nil)
        } else {
            return (Color(hex: brandColorHex), sfSymbolName, .white, nil)
        }
    }
}
