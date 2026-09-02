//
//  InsightsSummaryCard.swift
//  Renewly
//

import SwiftUI

enum InsightsPeriod: String, CaseIterable, Identifiable {
    case monthly = "Monthly"
    case yearly = "Yearly"
    
    var id: String { rawValue }
}

struct InsightsSummaryCard: View {
    let monthlyAmount: Double
    let yearlyAmount: Double
    let activeCount: Int
    var currency: String = "£"
    @Binding var selectedPeriod: InsightsPeriod
    
    private var displayAmount: Double {
        selectedPeriod == .monthly ? monthlyAmount : yearlyAmount
    }
    
    private var subtitleText: String {
        selectedPeriod == .monthly ? "estimated monthly spend" : "estimated yearly spend"
    }
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            // Background gradient
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(Color.renewlySpendingGradient)
            
            // Subtle wave line in background
            WaveGraphGraphic()
                .stroke(
                    LinearGradient(
                        colors: [Color.white.opacity(0.06), Color.white.opacity(0.25)],
                        startPoint: .leading,
                        endPoint: .trailing
                    ),
                    style: StrokeStyle(lineWidth: 2.2, lineCap: .round, lineJoin: .round)
                )
                .frame(height: 48)
                .padding(.trailing, 10)
                .padding(.bottom, 16)
            
            // Content
            VStack(alignment: .leading, spacing: 12) {
                // Top row: Period toggle
                HStack {
                    HStack(spacing: 4) {
                        ForEach(InsightsPeriod.allCases) { period in
                            let isSelected = selectedPeriod == period
                            Button(action: {
                                let impact = UIImpactFeedbackGenerator(style: .light)
                                impact.impactOccurred()
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.75)) {
                                    selectedPeriod = period
                                }
                            }) {
                                Text(period.rawValue)
                                    .font(.system(size: 12, weight: isSelected ? .bold : .medium))
                                    .foregroundColor(isSelected ? Color.renewlyPrimary : .white.opacity(0.8))
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(
                                        isSelected ?
                                        RoundedRectangle(cornerRadius: 10, style: .continuous).fill(Color.white) :
                                        RoundedRectangle(cornerRadius: 10, style: .continuous).fill(Color.clear)
                                    )
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(3)
                    .background(Color.black.opacity(0.15))
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    
                    Spacer()
                    
                    // Active Count Pill
                    HStack(spacing: 4) {
                        Circle()
                            .fill(Color(hex: "4CD964"))
                            .frame(width: 6, height: 6)
                        Text("\(activeCount) active")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(Color.white.opacity(0.18))
                    .clipShape(Capsule())
                }
                
                // Big Amount
                VStack(alignment: .leading, spacing: 3) {
                    Text(String(format: "%@%.2f", currency, displayAmount))
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .contentTransition(.numericText())
                    
                    Text(subtitleText)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.white.opacity(0.82))
                }
                .padding(.top, 2)
            }
            .padding(20)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(height: 154)
        .shadow(color: Color.renewlyPrimary.opacity(0.25), radius: 12, x: 0, y: 6)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(subtitleText): \(currency)\(String(format: "%.2f", displayAmount)). \(activeCount) active subscriptions.")
    }
}
