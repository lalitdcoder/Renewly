//
//  MonthOverMonthCard.swift
//  Renewly
//

import SwiftUI

struct MonthOverMonthCard: View {
    let comparison: MonthOverMonthSpendComparison
    var currency: String = "£"
    
    var body: some View {
        if comparison.hasComparison {
            HStack(spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(comparison.isIncrease ? Color.renewlyPrimaryLight : Color.renewlySuccessBg)
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: comparison.isIncrease ? "arrow.up.right" : "arrow.down.right")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(comparison.isIncrease ? Color.renewlyPrimary : Color.renewlySuccess)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(comparison.isIncrease ? "Your monthly spend increased" : "Your monthly spend decreased")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.renewlyTextPrimary)
                    
                    HStack(spacing: 6) {
                        Text(String(format: "%@%.2f → %@%.2f", currency, comparison.previousSpend, currency, comparison.currentSpend))
                            .font(.system(size: 14, weight: .bold, design: .rounded))
                            .foregroundColor(.renewlyTextPrimary)
                    }
                }
                
                Spacer()
                
                Text(comparison.formattedDifference(currency: currency))
                    .font(.system(size: 12, weight: .bold, design: .rounded))
                    .foregroundColor(comparison.isIncrease ? Color.renewlyPrimaryDark : Color.renewlySuccess)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(comparison.isIncrease ? Color.renewlyPrimaryLight : Color.renewlySuccessBg)
                    .clipShape(Capsule())
            }
            .padding(14)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(Color.renewlyCardBorder, lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.02), radius: 4, y: 1)
        }
    }
}
