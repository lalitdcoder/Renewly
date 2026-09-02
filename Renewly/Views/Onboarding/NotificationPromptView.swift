//
//  NotificationPromptView.swift
//  Renewly
//

import SwiftUI

struct NotificationPromptView: View {
    let onEnable: () -> Void
    let onSkip: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            // Bell Illustration
            OnboardingBellGraphic()
                .padding(.bottom, 20)
            
            // Typography
            VStack(spacing: 12) {
                Text("We'll help\nyou remember.")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(.renewlyTextPrimary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                
                Text("Get reminders before subscriptions renew and free trials end.")
                    .font(.system(size: 15, weight: .regular))
                    .foregroundColor(.renewlyTextSecondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(3)
                    .padding(.horizontal, 32)
            }
            .padding(.bottom, 32)
            
            // Example Notification Card Preview
            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(Color.renewlyPrimary)
                        .frame(width: 32, height: 32)
                    
                    Image(systemName: "bell.fill")
                        .font(.system(size: 15))
                        .foregroundColor(.white)
                }
                
                VStack(alignment: .leading, spacing: 3) {
                    HStack {
                        Text("Subscription Tracker")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(.renewlyTextPrimary)
                        
                        Spacer()
                        
                        Text("now")
                            .font(.system(size: 11, weight: .regular))
                            .foregroundColor(.renewlyTextMuted)
                    }
                    
                    Text("🔔 Netflix renews in 3 days")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.renewlyTextPrimary)
                }
            }
            .padding(14)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(Color.renewlyCardBorder, lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.06), radius: 12, y: 4)
            .padding(.horizontal, 28)
            
            Spacer()
            
            // Actions
            VStack(spacing: 14) {
                PrimaryButton(title: "Enable Reminders", action: onEnable)
                
                Button(action: onSkip) {
                    Text("Maybe later")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.renewlyPrimary)
                        .padding(.vertical, 8)
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 32)
        }
        .background(Color.renewlyBackground.ignoresSafeArea())
    }
}
