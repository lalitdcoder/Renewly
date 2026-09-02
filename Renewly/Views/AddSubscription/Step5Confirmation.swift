//
//  Step5Confirmation.swift
//  Renewly
//

import SwiftUI

struct Step5Confirmation: View {
    let name: String
    let iconAssetName: String?
    let sfSymbolName: String
    let brandColorHex: String
    let price: Double
    let currency: String
    let billingFrequency: BillingFrequency
    let renewalDate: Date
    let hasUnknownRenewalDate: Bool
    let onDone: () -> Void
    
    private var formattedRenewalText: String {
        if hasUnknownRenewalDate {
            return "Renewal date unknown"
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyyy"
        return "Renews " + formatter.string(from: renewalDate)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            // Confetti Checkmark Celebration
            ConfettiCheckmarkView()
                .padding(.bottom, 24)
            
            // Title matching Screen 11
            Text("✓ Subscription added")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.renewlySuccess)
                .padding(.bottom, 36)
            
            // Subscription Summary Card matching Screen 11
            HStack(spacing: 16) {
                ServiceIconView(
                    name: name,
                    iconAssetName: iconAssetName,
                    sfSymbolName: sfSymbolName,
                    brandColorHex: brandColorHex,
                    size: 48
                )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(name)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.renewlyTextPrimary)
                    
                    Text(String(format: "%@%.2f/%@", currency, price, billingFrequency.suffixText))
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(.renewlyTextSecondary)
                    
                    Text(formattedRenewalText)
                        .font(.system(size: 13, weight: .regular))
                        .foregroundColor(.renewlyTextMuted)
                }
                
                Spacer()
            }
            .padding(18)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(Color.renewlyCardBorder, lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.04), radius: 8, y: 2)
            .padding(.horizontal, 24)
            
            Spacer()
            
            // Done Button
            PrimaryButton(title: "Done", action: onDone)
                .padding(.horizontal, 24)
                .padding(.bottom, 32)
        }
    }
}
