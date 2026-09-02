//
//  FilterChip.swift
//  Renewly
//

import SwiftUI

struct FilterChip: View {
    let title: String
    let isSelected: Bool
    var count: Int? = nil
    let action: () -> Void
    
    var body: some View {
        Button(action: {
            let impact = UIImpactFeedbackGenerator(style: .light)
            impact.impactOccurred()
            action()
        }) {
            HStack(spacing: 6) {
                Text(title)
                    .font(.system(size: 13, weight: isSelected ? .semibold : .medium))
                
                if let count = count {
                    Text("\(count)")
                        .font(.system(size: 11, weight: .bold, design: .rounded))
                        .foregroundColor(isSelected ? Color.renewlyPrimary : Color(hex: "6C6C70"))
                        .padding(.horizontal, 6)
                        .padding(.vertical, 1.5)
                        .background(isSelected ? Color.white : Color(hex: "E5E5EA"))
                        .clipShape(Capsule())
                }
            }
            .foregroundColor(isSelected ? .white : Color(hex: "3A3A3C"))
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(
                Capsule()
                    .fill(isSelected ? Color.renewlyPrimary : Color(hex: "F2F2F7"))
            )
            .shadow(color: isSelected ? Color.renewlyPrimary.opacity(0.18) : .clear, radius: 4, y: 1)
        }
        .buttonStyle(SpringBounceButtonStyle())
        .accessibilityLabel("\(title) filter, \(count.map { "\($0) items" } ?? "")")
    }
}
