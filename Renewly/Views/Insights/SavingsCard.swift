//
//  SavingsCard.swift
//  Renewly
//

import SwiftUI

struct SavingsCard: View {
    let savings: SavingsSummary
    let potentialSavings: PotentialSavingsSummary
    var currency: String = "£"
    
    @State private var showAllPotentialItems: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            // MARK: - Section 1: Realized Money Saved
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("Money saved")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(.renewlyTextPrimary)
                    
                    Spacer()
                    
                    Text("Avoided costs")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.renewlyTextMuted)
                }
                
                if savings.hasSavings {
                    // Hero savings banner
                    HStack(spacing: 14) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .fill(Color.renewlySuccessBg)
                                .frame(width: 44, height: 44)
                            
                            Text("🎉")
                                .font(.system(size: 22))
                        }
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text(String(format: "%@%.2f", currency, savings.totalEstimatedAnnualSavings))
                                .font(.system(size: 22, weight: .bold, design: .rounded))
                                .foregroundColor(.renewlySuccess)
                            
                            Text("total estimated annual savings")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.renewlyTextSecondary)
                        }
                        
                        Spacer()
                    }
                    .padding(12)
                    .background(Color.renewlySuccessBg.opacity(0.4))
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .stroke(Color.renewlySuccess.opacity(0.15), lineWidth: 1)
                    )
                    
                    // Itemized avoided costs
                    VStack(spacing: 8) {
                        if savings.cancelledCount > 0 {
                            HStack {
                                HStack(spacing: 6) {
                                    Image(systemName: "xmark.circle.fill")
                                        .font(.system(size: 13))
                                        .foregroundColor(.renewlyAttention)
                                    Text("Cancelled subscriptions (\(savings.cancelledCount))")
                                        .font(.system(size: 13, weight: .medium))
                                        .foregroundColor(.renewlyTextPrimary)
                                }
                                
                                Spacer()
                                
                                Text(String(format: "+%@%.2f/yr", currency, savings.cancelledSubscriptionsAnnualSavings))
                                    .font(.system(size: 13, weight: .semibold, design: .rounded))
                                    .foregroundColor(.renewlySuccess)
                            }
                        }
                        
                        if savings.stoppedTrialCount > 0 {
                            HStack {
                                HStack(spacing: 6) {
                                    Image(systemName: "gift.fill")
                                        .font(.system(size: 13))
                                        .foregroundColor(Color.renewlyTrialAmber)
                                    Text("Stopped trials (\(savings.stoppedTrialCount))")
                                        .font(.system(size: 13, weight: .medium))
                                        .foregroundColor(.renewlyTextPrimary)
                                }
                                
                                Spacer()
                                
                                Text(String(format: "+%@%.2f/yr", currency, savings.stoppedTrialsSavings))
                                    .font(.system(size: 13, weight: .semibold, design: .rounded))
                                    .foregroundColor(.renewlySuccess)
                            }
                        }
                    }
                    .padding(.top, 2)
                } else {
                    // Encouraging empty state
                    HStack(spacing: 12) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .fill(Color(hex: "F2F2F6"))
                                .frame(width: 38, height: 38)
                            
                            Image(systemName: "checkmark.seal.fill")
                                .font(.system(size: 18))
                                .foregroundColor(.renewlyTextMuted)
                        }
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("No cancelled subscriptions yet")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(.renewlyTextPrimary)
                            Text("Avoided costs from cancelled subscriptions or ended trials will show here.")
                                .font(.system(size: 12))
                                .foregroundColor(.renewlyTextSecondary)
                        }
                    }
                    .padding(.vertical, 2)
                }
            }
            
            // MARK: - Section 2: Potential Savings (Informational)
            if potentialSavings.hasItems {
                Divider().background(Color.renewlyDivider)
                
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Potential savings")
                                .font(.system(size: 15, weight: .bold))
                                .foregroundColor(.renewlyTextPrimary)
                            
                            Text("Annualized costs for your active subscriptions")
                                .font(.system(size: 12))
                                .foregroundColor(.renewlyTextSecondary)
                        }
                        
                        Spacer()
                    }
                    
                    // Display potential items
                    let displayedItems = showAllPotentialItems ? potentialSavings.items : Array(potentialSavings.items.prefix(3))
                    
                    VStack(spacing: 10) {
                        ForEach(displayedItems) { item in
                            HStack(spacing: 10) {
                                ServiceIconView(
                                    name: item.name,
                                    iconAssetName: item.iconAssetName,
                                    sfSymbolName: item.sfSymbolName,
                                    brandColorHex: item.brandColorHex,
                                    size: 34
                                )
                                
                                VStack(alignment: .leading, spacing: 1) {
                                    Text(item.name)
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(.renewlyTextPrimary)
                                    
                                    Text(String(format: "%@%.2f / month", item.currency, item.monthlyCost))
                                        .font(.system(size: 12))
                                        .foregroundColor(.renewlyTextSecondary)
                                }
                                
                                Spacer()
                                
                                Text(String(format: "%@%.2f / year", item.currency, item.yearlyCost))
                                    .font(.system(size: 13, weight: .semibold, design: .rounded))
                                    .foregroundColor(.renewlyTextPrimary)
                            }
                        }
                        
                        if potentialSavings.items.count > 3 {
                            Button(action: {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                    showAllPotentialItems.toggle()
                                }
                            }) {
                                HStack(spacing: 4) {
                                    Text(showAllPotentialItems ? "Show fewer" : "Show all (\(potentialSavings.items.count))")
                                        .font(.system(size: 12, weight: .semibold))
                                    Image(systemName: showAllPotentialItems ? "chevron.up" : "chevron.down")
                                        .font(.system(size: 10, weight: .bold))
                                }
                                .foregroundColor(.renewlyPrimary)
                                .padding(.top, 4)
                            }
                        }
                    }
                    
                    // Summary Banner
                    HStack(spacing: 12) {
                        VStack(alignment: .leading, spacing: 1) {
                            Text(String(format: "%@%.2f / year", currency, potentialSavings.totalAnnualPotentialSavings))
                                .font(.system(size: 17, weight: .bold, design: .rounded))
                                .foregroundColor(.renewlyPrimary)
                            
                            Text("potential savings if all active subscriptions were cancelled")
                                .font(.system(size: 11, weight: .regular))
                                .foregroundColor(.renewlyTextSecondary)
                        }
                        
                        Spacer()
                    }
                    .padding(12)
                    .background(Color.renewlyPrimaryUltraLight)
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .stroke(Color.renewlyPrimaryLight, lineWidth: 1)
                    )
                }
            }
        }
        .padding(18)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(Color.renewlyCardBorder, lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.02), radius: 4, y: 1)
    }
}
