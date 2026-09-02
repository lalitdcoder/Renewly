//
//  NotificationsSheetView.swift
//  Renewly
//

import SwiftUI

struct NotificationsSheetView: View {
    @Environment(\.dismiss) private var dismiss
    let subscriptions: [SubscriptionModel]
    
    private var alertItems: [SubscriptionModel] {
        subscriptions
            .filter { $0.status == .active && $0.nextRenewalDate != nil }
            .sorted { ($0.nextRenewalDate ?? Date()) < ($1.nextRenewalDate ?? Date()) }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 12) {
                    if alertItems.isEmpty {
                        VStack(spacing: 12) {
                            Image(systemName: "bell.slash")
                                .font(.system(size: 40))
                                .foregroundColor(.renewlyTextMuted)
                                .padding(.top, 40)
                            
                            Text("No Upcoming Alerts")
                                .font(.system(size: 17, weight: .bold))
                                .foregroundColor(.renewlyTextPrimary)
                            
                            Text("When you have subscriptions renewing or trials ending, you'll see alerts here.")
                                .font(.system(size: 14))
                                .foregroundColor(.renewlyTextSecondary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 32)
                        }
                    } else {
                        ForEach(alertItems) { sub in
                            HStack(spacing: 14) {
                                ServiceIconView(
                                    name: sub.name,
                                    iconAssetName: sub.iconAssetName,
                                    sfSymbolName: sub.sfSymbolName,
                                    brandColorHex: sub.brandColorHex,
                                    size: 40
                                )
                                
                                VStack(alignment: .leading, spacing: 3) {
                                    HStack {
                                        Text(sub.name)
                                            .font(.system(size: 15, weight: .bold))
                                            .foregroundColor(.renewlyTextPrimary)
                                        
                                        Spacer()
                                        
                                        Text(sub.renewalBadgeText())
                                            .font(.system(size: 11, weight: .semibold))
                                            .foregroundColor(sub.isUrgent ? .renewlyAttention : .renewlyPrimary)
                                            .padding(.horizontal, 8)
                                            .padding(.vertical, 3)
                                            .background(sub.isUrgent ? Color.renewlyAttentionBg : Color.renewlyPrimaryLight)
                                            .clipShape(Capsule())
                                    }
                                    
                                    Text(sub.statusSubtitle())
                                        .font(.system(size: 13))
                                        .foregroundColor(.renewlyTextSecondary)
                                }
                            }
                            .padding(14)
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                            .overlay(
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .stroke(Color.renewlyCardBorder, lineWidth: 1)
                            )
                        }
                    }
                }
                .padding(20)
            }
            .background(Color.renewlyBackground.ignoresSafeArea())
            .navigationTitle("Alerts & Reminders")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.renewlyPrimary)
                }
            }
        }
    }
}
