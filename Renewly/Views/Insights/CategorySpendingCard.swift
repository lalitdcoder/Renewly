//
//  CategorySpendingCard.swift
//  Renewly
//

import SwiftUI

struct CategorySpendingCard: View {
    let categories: [CategorySpendItem]
    var currency: String = "£"
    var isYearly: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text("Spending by category")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.renewlyTextPrimary)
                
                Spacer()
                
                Text("\(categories.count) categories")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.renewlyTextMuted)
            }
            
            if categories.isEmpty {
                Text("No active subscriptions in categories.")
                    .font(.system(size: 13))
                    .foregroundColor(.renewlyTextSecondary)
                    .padding(.vertical, 8)
            } else {
                // Multi-Segment Horizontal Bar
                GeometryReader { geo in
                    HStack(spacing: 2) {
                        ForEach(categories) { item in
                            let segmentWidth = max(geo.size.width * CGFloat(item.percentage / 100.0) - 2, 4)
                            RoundedRectangle(cornerRadius: 4, style: .continuous)
                                .fill(item.color)
                                .frame(width: segmentWidth, height: 10)
                        }
                    }
                }
                .frame(height: 10)
                .padding(.bottom, 6)
                
                // Itemized Category List
                VStack(spacing: 12) {
                    ForEach(categories) { item in
                        HStack(spacing: 12) {
                            // Category Icon
                            ZStack {
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .fill(item.color.opacity(0.15))
                                    .frame(width: 32, height: 32)
                                
                                Image(systemName: item.category.iconName)
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(item.color)
                            }
                            
                            // Name & Count
                            VStack(alignment: .leading, spacing: 1) {
                                Text(item.category.rawValue)
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.renewlyTextPrimary)
                                
                                Text("\(item.subscriptionCount) sub\(item.subscriptionCount == 1 ? "" : "s") · \(String(format: "%.0f%%", item.percentage))")
                                    .font(.system(size: 12))
                                    .foregroundColor(.renewlyTextSecondary)
                            }
                            
                            Spacer()
                            
                            // Amount
                            let amount = isYearly ? item.yearlyAmount : item.monthlyAmount
                            Text(String(format: "%@%.2f%@", currency, amount, isYearly ? "/yr" : "/mo"))
                                .font(.system(size: 14, weight: .bold, design: .rounded))
                                .foregroundColor(.renewlyTextPrimary)
                        }
                    }
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
