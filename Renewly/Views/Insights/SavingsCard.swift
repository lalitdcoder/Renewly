//
//  SavingsCard.swift
//  Renewly
//

import SwiftUI

struct SavingsCard: View {
    let savings: SavingsSummary
    var currency: String = "£"
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text("Money saved")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.renewlyTextPrimary)
                
                Spacer()
                
                Text("Annual estimate")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.renewlyTextMuted)
            }
            
            if savings.hasSavings {
                // Hero savings banner
                HStack(spacing: 14) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .fill(Color.renewlySuccessBg)
                            .frame(width: 48, height: 48)
                        
                        Text("🎉")
                            .font(.system(size: 24))
                    }
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(String(format: "%@%.2f", currency, savings.totalEstimatedAnnualSavings))
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                            .foregroundColor(.renewlySuccess)
                        
                        Text("total estimated annual savings")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.renewlyTextSecondary)
                    }
                    
                    Spacer()
                }
                .padding(14)
                .background(Color.renewlySuccessBg.opacity(0.4))
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .stroke(Color.renewlySuccess.opacity(0.15), lineWidth: 1)
                )
                
                // Itemized Breakdown
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
                            .fill(Color.renewlyPrimaryLight)
                            .frame(width: 42, height: 42)
                        
                        Image(systemName: "checkmark.seal.fill")
                            .font(.system(size: 20))
                            .foregroundColor(.renewlyPrimary)
                    }
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("No cancelled subscriptions yet")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.renewlyTextPrimary)
                        Text("When you cancel subscriptions or end trials before billing, your avoided costs will be tracked here.")
                            .font(.system(size: 12))
                            .foregroundColor(.renewlyTextSecondary)
                    }
                }
                .padding(.vertical, 4)
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
        .accessibilityElement(children: .combine)
        .accessibilityLabel(savings.hasSavings ? String(format: "Money saved: %@%.2f annual estimated savings.", currency, savings.totalEstimatedAnnualSavings) : "No cancelled subscriptions yet.")
    }
}
