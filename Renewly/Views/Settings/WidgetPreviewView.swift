//
//  WidgetPreviewView.swift
//  Renewly
//

import SwiftUI
import SwiftData

struct WidgetPreviewView: View {
    @Environment(\.dismiss) private var dismiss
    @Query private var subscriptions: [SubscriptionModel]
    
    private var currency: String {
        UserPreferences.shared.currency.rawValue
    }
    
    private var monthlySpend: Double {
        SpendingCalculator.totalMonthlySpending(subscriptions: subscriptions)
    }
    
    private var radarItems: [SubscriptionModel] {
        SpendingCalculator.renewalRadarItems(subscriptions: subscriptions, withinDays: 14)
    }
    
    private var nextUpcoming: SubscriptionModel? {
        radarItems.first ?? subscriptions.first
    }
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    // Header Description
                    VStack(spacing: 6) {
                        Text("Renewly on your Home Screen")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.renewlyTextPrimary)
                        
                        Text("Stay on top of upcoming renewals and active trials right from your iOS Home Screen and Lock Screen.")
                            .font(.system(size: 14))
                            .foregroundColor(.renewlyTextSecondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 16)
                    }
                    .padding(.top, 8)
                    
                    // MARK: - 1. Small Widget Preview
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Small Widget · Next Renewal")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(.renewlyTextSecondary)
                            .textCase(.uppercase)
                            .padding(.horizontal, 4)
                        
                        HStack {
                            Spacer()
                            SmallWidgetCard(
                                subscription: nextUpcoming,
                                currency: currency
                            )
                            .frame(width: 160, height: 160)
                            .shadow(color: Color.black.opacity(0.08), radius: 12, y: 4)
                            Spacer()
                        }
                    }
                    .padding(.horizontal, 24)
                    
                    // MARK: - 2. Medium Widget Preview
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Medium Widget · Monthly Spend & Radar")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(.renewlyTextSecondary)
                            .textCase(.uppercase)
                            .padding(.horizontal, 4)
                        
                        MediumWidgetCard(
                            monthlyTotal: monthlySpend,
                            upcomingItems: Array(radarItems.prefix(2)),
                            currency: currency
                        )
                        .frame(maxWidth: .infinity)
                        .frame(height: 160)
                        .shadow(color: Color.black.opacity(0.08), radius: 12, y: 4)
                    }
                    .padding(.horizontal, 24)
                    
                    // MARK: - 3. Lock Screen Widget Preview
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Lock Screen Widget · Rectangular")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(.renewlyTextSecondary)
                            .textCase(.uppercase)
                            .padding(.horizontal, 4)
                        
                        HStack {
                            Spacer()
                            LockScreenWidgetCard(
                                subscription: nextUpcoming,
                                currency: currency
                            )
                            .frame(width: 220, height: 72)
                            .shadow(color: Color.black.opacity(0.2), radius: 8, y: 3)
                            Spacer()
                        }
                    }
                    .padding(.horizontal, 24)
                    
                    // MARK: - Setup instructions
                    VStack(alignment: .leading, spacing: 12) {
                        Text("How to add widgets to Home Screen")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(.renewlyTextPrimary)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            InstructionStepRow(number: "1", text: "Touch and hold an empty area on your Home Screen until the apps jiggle.")
                            InstructionStepRow(number: "2", text: "Tap the + button in the upper-left corner.")
                            InstructionStepRow(number: "3", text: "Search for Renewly, select your desired widget size, and tap Add Widget.")
                        }
                    }
                    .padding(18)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                            .stroke(Color.renewlyCardBorder, lineWidth: 1)
                    )
                    .padding(.horizontal, 24)
                    .padding(.bottom, 24)
                }
            }
            .background(Color.renewlyBackground.ignoresSafeArea())
            .navigationTitle("Widgets")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
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

// MARK: - Small Widget View
struct SmallWidgetCard: View {
    let subscription: SubscriptionModel?
    let currency: String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 22, style: .continuous)
                        .stroke(Color.renewlyCardBorder, lineWidth: 1)
                )
            
            if let sub = subscription {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        ServiceIconView(
                            name: sub.name,
                            iconAssetName: sub.iconAssetName,
                            sfSymbolName: sub.sfSymbolName,
                            brandColorHex: sub.brandColorHex,
                            size: 32,
                            cornerRadius: 9
                        )
                        
                        Spacer()
                        
                        Text(sub.radarCountdownText())
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(sub.isUrgent ? Color.renewlyAttention : Color.renewlyPrimary)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 3)
                            .background(sub.isUrgent ? Color.renewlyAttentionBg : Color.renewlyPrimaryLight)
                            .clipShape(Capsule())
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(sub.name)
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.renewlyTextPrimary)
                            .lineLimit(1)
                        
                        Text(sub.type == .trial ? "Free Trial" : String(format: "%@%.2f %@", currency, sub.price, sub.billingFrequency.shortLabel))
                            .font(.system(size: 13, weight: .semibold, design: .rounded))
                            .foregroundColor(.renewlyPrimary)
                        
                        if let renewal = sub.nextRenewalDate {
                            Text("Renews \(formatRenewalDate(renewal))")
                                .font(.system(size: 11))
                                .foregroundColor(.renewlyTextSecondary)
                        }
                    }
                }
                .padding(14)
            } else {
                VStack(spacing: 6) {
                    Image(systemName: "sparkles")
                        .font(.system(size: 24))
                        .foregroundColor(.renewlyPrimary)
                    Text("No renewals")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(.renewlyTextPrimary)
                }
                .padding(14)
            }
        }
    }
    
    private func formatRenewalDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter.string(from: date)
    }
}

// MARK: - Medium Widget View
struct MediumWidgetCard: View {
    let monthlyTotal: Double
    let upcomingItems: [SubscriptionModel]
    let currency: String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 22, style: .continuous)
                        .stroke(Color.renewlyCardBorder, lineWidth: 1)
                )
            
            HStack(spacing: 16) {
                // Left column: Monthly spend
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 4) {
                        Image(systemName: "creditcard.fill")
                            .font(.system(size: 11))
                            .foregroundColor(.renewlyPrimary)
                        Text("Renewly")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(.renewlyPrimary)
                    }
                    
                    Spacer()
                    
                    Text(String(format: "%@%.2f", currency, monthlyTotal))
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                        .foregroundColor(.renewlyTextPrimary)
                    
                    Text("Monthly spend")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(.renewlyTextSecondary)
                }
                .frame(maxWidth: 110, alignment: .leading)
                
                Divider().background(Color.renewlyDivider)
                
                // Right column: Upcoming renewals
                VStack(alignment: .leading, spacing: 8) {
                    Text("Coming Up")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(.renewlyTextSecondary)
                        .textCase(.uppercase)
                    
                    if upcomingItems.isEmpty {
                        Text("No renewals due soon")
                            .font(.system(size: 12))
                            .foregroundColor(.renewlyTextSecondary)
                    } else {
                        ForEach(upcomingItems) { item in
                            HStack(spacing: 8) {
                                ServiceIconView(
                                    name: item.name,
                                    iconAssetName: item.iconAssetName,
                                    sfSymbolName: item.sfSymbolName,
                                    brandColorHex: item.brandColorHex,
                                    size: 26,
                                    cornerRadius: 7
                                )
                                
                                VStack(alignment: .leading, spacing: 1) {
                                    Text(item.name)
                                        .font(.system(size: 12, weight: .bold))
                                        .foregroundColor(.renewlyTextPrimary)
                                        .lineLimit(1)
                                    
                                    Text(item.radarCountdownText())
                                        .font(.system(size: 10, weight: .medium))
                                        .foregroundColor(item.isUrgent ? Color.renewlyAttention : Color.renewlyPrimary)
                                }
                                
                                Spacer()
                                
                                Text(item.type == .trial ? "Trial" : String(format: "%@%.2f", currency, item.price))
                                    .font(.system(size: 12, weight: .semibold, design: .rounded))
                                    .foregroundColor(.renewlyTextPrimary)
                            }
                        }
                    }
                    
                    Spacer(minLength: 0)
                }
            }
            .padding(14)
        }
    }
}

// MARK: - Lock Screen Widget View
struct LockScreenWidgetCard: View {
    let subscription: SubscriptionModel?
    let currency: String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color.black.opacity(0.85))
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                )
            
            if let sub = subscription {
                HStack(spacing: 10) {
                    Image(systemName: sub.sfSymbolName)
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.white)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(sub.name)
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text(sub.type == .trial ? "Trial ends in \(sub.daysUntilRenewal() ?? 0) days" : "\(sub.radarCountdownText()) · \(currency)\(String(format: "%.2f", sub.price))")
                            .font(.system(size: 12))
                            .foregroundColor(.white.opacity(0.8))
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 14)
            } else {
                Text("Renewly · No upcoming renewals")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.white)
            }
        }
    }
}

struct InstructionStepRow: View {
    let number: String
    let text: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            ZStack {
                Circle()
                    .fill(Color.renewlyPrimaryLight)
                    .frame(width: 22, height: 22)
                Text(number)
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.renewlyPrimary)
            }
            
            Text(text)
                .font(.system(size: 13))
                .foregroundColor(.renewlyTextPrimary)
        }
    }
}
