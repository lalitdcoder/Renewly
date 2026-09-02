//
//  SpendingTrendCard.swift
//  Renewly
//

import SwiftUI

struct SpendingTrendCard: View {
    let timelinePoints: [SpendingTimelinePoint]
    var currency: String = "£"
    
    private var maxAmount: Double {
        let maxVal = timelinePoints.map(\.amount).max() ?? 100.0
        return max(maxVal * 1.15, 10.0)
    }
    
    private var accessibilitySummary: String {
        guard let first = timelinePoints.first, let last = timelinePoints.last else {
            return "Spending trend over time."
        }
        return "Spending over time from \(first.monthLabel) at \(currency)\(String(format: "%.2f", first.amount)) to \(last.monthLabel) at \(currency)\(String(format: "%.2f", last.amount))."
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            // Header
            HStack {
                Text("Spending over time")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.renewlyTextPrimary)
                
                Spacer()
                
                Text("Past 6 months")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.renewlyTextMuted)
            }
            
            if timelinePoints.isEmpty {
                // Limited data state
                HStack(spacing: 12) {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                        .font(.system(size: 24))
                        .foregroundColor(.renewlyTextMuted)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Not enough history yet")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.renewlyTextPrimary)
                        Text("Keep tracking your subscriptions and your spending trend will appear here.")
                            .font(.system(size: 12))
                            .foregroundColor(.renewlyTextSecondary)
                    }
                }
                .padding(.vertical, 16)
            } else {
                // Clean Minimalist Chart
                VStack(spacing: 8) {
                    HStack(alignment: .bottom, spacing: 10) {
                        ForEach(timelinePoints) { point in
                            let normalizedHeight = CGFloat(point.amount / maxAmount) * 90.0
                            
                            VStack(spacing: 6) {
                                // Amount label
                                Text(String(format: "%@%.0f", currency, point.amount))
                                    .font(.system(size: 10, weight: .semibold, design: .rounded))
                                    .foregroundColor(point.isCurrentOrProjected ? Color.renewlyPrimary : Color.renewlyTextMuted)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.7)
                                
                                // Vertical rounded bar
                                ZStack(alignment: .bottom) {
                                    Capsule()
                                        .fill(Color(hex: "F2F2F7"))
                                        .frame(width: 22, height: 90)
                                    
                                    Capsule()
                                        .fill(
                                            point.isCurrentOrProjected ?
                                            LinearGradient(
                                                colors: [Color(hex: "6354EC"), Color(hex: "816EF8")],
                                                startPoint: .bottom,
                                                endPoint: .top
                                            ) :
                                            LinearGradient(
                                                colors: [Color(hex: "C5C0F6"), Color(hex: "D8D4FA")],
                                                startPoint: .bottom,
                                                endPoint: .top
                                            )
                                        )
                                        .frame(width: 22, height: max(normalizedHeight, 8))
                                }
                                
                                // Month Label
                                Text(point.monthLabel)
                                    .font(.system(size: 11, weight: point.isCurrentOrProjected ? .bold : .medium))
                                    .foregroundColor(point.isCurrentOrProjected ? Color.renewlyPrimary : Color.renewlyTextSecondary)
                            }
                            .frame(maxWidth: .infinity)
                        }
                    }
                    .frame(height: 130)
                }
                .padding(.top, 4)
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
        .accessibilityLabel(accessibilitySummary)
    }
}
