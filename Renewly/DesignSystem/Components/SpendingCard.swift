//
//  SpendingCard.swift
//  Renewly
//

import SwiftUI

struct SpendingCard: View {
    let monthlyAmount: Double
    let yearlyAmount: Double
    var currency: String = "£"
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            // Background gradient
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(Color.renewlySpendingGradient)
            
            // Subtle decorative wave chart graphic in background
            WaveGraphGraphic()
                .stroke(
                    LinearGradient(
                        colors: [Color.white.opacity(0.05), Color.white.opacity(0.28)],
                        startPoint: .leading,
                        endPoint: .trailing
                    ),
                    style: StrokeStyle(lineWidth: 2.2, lineCap: .round, lineJoin: .round)
                )
                .frame(height: 44)
                .padding(.trailing, 12)
                .padding(.bottom, 16)
            
            // Card Content
            VStack(alignment: .leading, spacing: 4) {
                // Monthly amount - Hero Element
                Text(String(format: "%@%.2f", currency, monthlyAmount))
                    .font(.system(size: 34, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .contentTransition(.numericText())
                
                Text("estimated monthly subscriptions")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.white.opacity(0.82))
                
                Spacer(minLength: 12)
                
                // Yearly amount - Secondary Element
                HStack(spacing: 4) {
                    Text(String(format: "%@%.2f", currency, yearlyAmount))
                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                    Text("/year")
                        .font(.system(size: 12, weight: .regular))
                        .opacity(0.75)
                }
                .foregroundColor(.white)
            }
            .padding(20)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(height: 136)
        .shadow(color: Color.renewlyPrimary.opacity(0.25), radius: 12, x: 0, y: 6)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(String(format: "Estimated monthly spending: %@%.2f. Yearly estimate: %@%.2f", currency, monthlyAmount, currency, yearlyAmount))
    }
}

struct WaveGraphGraphic: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.width * 0.5
        let startX = rect.width - width
        
        path.move(to: CGPoint(x: startX, y: rect.height * 0.75))
        
        path.addCurve(
            to: CGPoint(x: startX + width * 0.5, y: rect.height * 0.6),
            control1: CGPoint(x: startX + width * 0.2, y: rect.height * 0.85),
            control2: CGPoint(x: startX + width * 0.35, y: rect.height * 0.45)
        )
        
        path.addCurve(
            to: CGPoint(x: rect.width - 8, y: rect.height * 0.15),
            control1: CGPoint(x: startX + width * 0.7, y: rect.height * 0.75),
            control2: CGPoint(x: startX + width * 0.85, y: rect.height * 0.1)
        )
        
        return path
    }
}
