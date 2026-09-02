//
//  WelcomeView.swift
//  Renewly
//

import SwiftUI

struct WelcomeView: View {
    let onGetStarted: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            // 3D Wallet Illustration
            OnboardingWalletGraphic()
                .padding(.bottom, 24)
            
            // Typography
            VStack(spacing: 12) {
                Text("Never forget a\nsubscription again.")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(.renewlyTextPrimary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                
                Text("Track subscriptions and free trials in one simple place. Get reminded before they renew.")
                    .font(.system(size: 15, weight: .regular))
                    .foregroundColor(.renewlyTextSecondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(3)
                    .padding(.horizontal, 28)
            }
            
            Spacer()
            
            // Bottom Action Area
            VStack(spacing: 16) {
                PrimaryButton(title: "Get Started", action: onGetStarted)
                
                HStack(spacing: 6) {
                    Image(systemName: "lock.fill")
                        .font(.system(size: 12))
                    Text("No bank connection required.")
                        .font(.system(size: 13, weight: .medium))
                }
                .foregroundColor(.renewlyTextMuted)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 32)
        }
        .background(Color.renewlyBackground.ignoresSafeArea())
    }
}
