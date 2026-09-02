//
//  OnboardingWalletGraphic.swift
//  Renewly
//

import SwiftUI

struct OnboardingWalletGraphic: View {
    @State private var floatAnimation = false
    
    var body: some View {
        ZStack {
            // Background soft glow
            Circle()
                .fill(Color.renewlyPrimaryLight.opacity(0.6))
                .frame(width: 220, height: 220)
                .blur(radius: 30)
            
            // Central 3D Wallet Illustration
            ZStack {
                // Wallet body
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [Color(hex: "705DF8"), Color(hex: "5641EB")],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 140, height: 110)
                    .shadow(color: Color.renewlyPrimary.opacity(0.35), radius: 18, x: 0, y: 12)
                    .rotationEffect(.degrees(-10))
                
                // Credit card 1 peeking out
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [Color(hex: "4CD964"), Color(hex: "27AE60")],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 110, height: 65)
                    .offset(x: -8, y: -38)
                    .rotationEffect(.degrees(-14))
                
                // Credit card 2 peeking out
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [Color(hex: "5AC8FA"), Color(hex: "007AFF")],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 105, height: 60)
                    .offset(x: 4, y: -30)
                    .rotationEffect(.degrees(-6))
                
                // Wallet flap & golden clasp
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [Color(hex: "6451F6"), Color(hex: "4B35E0")],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 140, height: 100)
                    .offset(y: 6)
                    .rotationEffect(.degrees(-10))
                
                // Gold clasp
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color(hex: "FFDF00"), Color(hex: "E6AC00")],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: 18, height: 18)
                    .shadow(color: Color.black.opacity(0.15), radius: 2, y: 1)
                    .offset(x: 34, y: 10)
            }
            .offset(y: floatAnimation ? -6 : 4)
            
            // Floating satellite brand icons matching Screen 01
            // 1. iCloud (top left)
            FloatingIconBubble(
                assetName: "iCloud",
                fallbackSymbol: "icloud.fill",
                brandColor: Color(hex: "3388FF"),
                size: 38
            )
            .offset(x: -105, y: -65 + (floatAnimation ? 5 : -5))
            
            // 2. Netflix (top middle-left)
            FloatingIconBubble(
                assetName: "Netflix",
                fallbackSymbol: "play.rectangle.fill",
                brandColor: Color(hex: "E50914"),
                size: 42
            )
            .offset(x: -45, y: -100 + (floatAnimation ? -4 : 4))
            
            // 3. Spotify (top middle-right)
            FloatingIconBubble(
                assetName: "Spotify",
                fallbackSymbol: "music.note",
                brandColor: Color(hex: "1DB954"),
                size: 42
            )
            .offset(x: 35, y: -95 + (floatAnimation ? 6 : -6))
            
            // 4. Disney+ (top right)
            FloatingIconBubble(
                assetName: "DisneyPlus",
                fallbackSymbol: "sparkles.tv.fill",
                brandColor: Color(hex: "113CCF"),
                size: 38
            )
            .offset(x: 100, y: -55 + (floatAnimation ? -5 : 5))
        }
        .frame(height: 250)
        .onAppear {
            withAnimation(.easeInOut(duration: 2.2).repeatForever(autoreverses: true)) {
                floatAnimation = true
            }
        }
    }
}

struct FloatingIconBubble: View {
    let assetName: String
    let fallbackSymbol: String
    let brandColor: Color
    let size: CGFloat
    
    var body: some View {
        ServiceIconView(
            name: assetName,
            iconAssetName: assetName,
            sfSymbolName: fallbackSymbol,
            brandColorHex: "6354EC",
            size: size,
            cornerRadius: size * 0.28
        )
        .shadow(color: Color.black.opacity(0.12), radius: 8, y: 4)
    }
}
