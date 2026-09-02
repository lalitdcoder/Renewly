//
//  RadioOptionRow.swift
//  Renewly
//

import SwiftUI

struct RadioOptionRow: View {
    let title: String
    var subtitle: String? = nil
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: {
            let impact = UIImpactFeedbackGenerator(style: .light)
            impact.impactOccurred()
            action()
        }) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.renewlyTextPrimary)
                    
                    if let subtitle = subtitle {
                        Text(subtitle)
                            .font(.system(size: 12, weight: .regular))
                            .foregroundColor(.renewlyTextSecondary)
                    }
                }
                
                Spacer()
                
                // Custom radio circle
                ZStack {
                    Circle()
                        .stroke(isSelected ? Color.renewlyPrimary : Color(hex: "D1D1D6"), lineWidth: 2)
                        .frame(width: 22, height: 22)
                    
                    if isSelected {
                        Circle()
                            .fill(Color.renewlyPrimary)
                            .frame(width: 12, height: 12)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(isSelected ? Color.renewlyPrimary.opacity(0.4) : Color.renewlyCardBorder, lineWidth: 1)
            )
            .shadow(color: isSelected ? Color.renewlyPrimary.opacity(0.06) : Color.black.opacity(0.02), radius: 4, y: 1)
        }
        .buttonStyle(SpringBounceButtonStyle())
    }
}
