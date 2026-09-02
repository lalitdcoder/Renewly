//
//  FastSetupSuccessView.swift
//  Renewly
//

import SwiftUI

struct FastSetupSuccessView: View {
    let savedItems: [FastSetupItem]
    let onFinish: () -> Void
    
    @State private var hasRequestedNotifications = false
    @State private var isNotificationEnabled = false
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    // Celebration Header
                    VStack(spacing: 12) {
                        ConfettiCheckmarkView()
                            .padding(.top, 16)
                        
                        Text("You're all set 🎉")
                            .font(.system(size: 26, weight: .bold))
                            .foregroundColor(.renewlyTextPrimary)
                        
                        Text("\(savedItems.count) subscription\(savedItems.count == 1 ? "" : "s") tracked and ready.")
                            .font(.system(size: 15, weight: .medium))
                            .foregroundColor(.renewlyTextSecondary)
                    }
                    .padding(.horizontal, 24)
                    
                    // Compact Summary Card
                    VStack(spacing: 0) {
                        ForEach(Array(savedItems.enumerated()), id: \.element.id) { index, item in
                            HStack(spacing: 12) {
                                ServiceIconView(
                                    name: item.name,
                                    iconAssetName: item.iconAssetName,
                                    sfSymbolName: item.sfSymbolName,
                                    brandColorHex: item.brandColorHex,
                                    size: 36,
                                    cornerRadius: 10
                                )
                                
                                Text(item.name)
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(.renewlyTextPrimary)
                                
                                Spacer()
                                
                                Text(item.isTrial ? "Free Trial" : String(format: "%@%.2f/%@", item.currency, item.price, item.billingFrequency == .yearly ? "yr" : "mo"))
                                    .font(.system(size: 13, weight: .semibold, design: .rounded))
                                    .foregroundColor(.renewlyTextSecondary)
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            
                            if index < savedItems.count - 1 {
                                Divider()
                                    .background(Color.renewlyDivider)
                                    .padding(.leading, 64)
                            }
                        }
                    }
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                            .stroke(Color.renewlyCardBorder, lineWidth: 1)
                    )
                    .shadow(color: Color.black.opacity(0.02), radius: 4, y: 1)
                    .padding(.horizontal, 24)
                    
                    // Notification Permission Benefit Card
                    if !hasRequestedNotifications {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack(spacing: 12) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                                        .fill(Color.renewlyPrimaryLight)
                                        .frame(width: 40, height: 40)
                                    
                                    Image(systemName: "bell.badge.fill")
                                        .font(.system(size: 18))
                                        .foregroundColor(.renewlyPrimary)
                                }
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("Never miss a renewal charge")
                                        .font(.system(size: 15, weight: .bold))
                                        .foregroundColor(.renewlyTextPrimary)
                                    Text("We'll send helpful alerts before trials end or subscriptions renew.")
                                        .font(.system(size: 12))
                                        .foregroundColor(.renewlyTextSecondary)
                                }
                            }
                            
                            Button(action: {
                                Task {
                                    let granted = await NotificationManager.shared.requestAuthorization()
                                    await MainActor.run {
                                        withAnimation {
                                            hasRequestedNotifications = true
                                            isNotificationEnabled = granted
                                        }
                                    }
                                }
                            }) {
                                HStack {
                                    Image(systemName: "bell.fill")
                                    Text("Enable Reminders")
                                }
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                                .background(Color.renewlyPrimary)
                                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                            }
                        }
                        .padding(16)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 18, style: .continuous)
                                .stroke(Color.renewlyPrimary.opacity(0.2), lineWidth: 1)
                        )
                        .shadow(color: Color.renewlyPrimary.opacity(0.05), radius: 4, y: 1)
                        .padding(.horizontal, 24)
                    }
                }
                .padding(.bottom, 24)
            }
            
            // Go to Home Button
            VStack(spacing: 0) {
                PrimaryButton(title: "Go to Home", action: onFinish)
                    .padding(.horizontal, 24)
                    .padding(.top, 12)
                    .padding(.bottom, 16)
            }
            .background(
                Color.white
                    .shadow(color: Color.black.opacity(0.04), radius: 8, y: -2)
                    .ignoresSafeArea(edges: .bottom)
            )
        }
        .background(Color.renewlyBackground.ignoresSafeArea())
    }
}
