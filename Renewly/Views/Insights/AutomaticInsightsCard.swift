//
//  AutomaticInsightsCard.swift
//  Renewly
//

import SwiftUI

struct AutomaticInsightsCard: View {
    let insights: [AutomaticInsightItem]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Your insights")
                .font(.system(size: 15, weight: .bold))
                .foregroundColor(.renewlyTextPrimary)
            
            if insights.isEmpty {
                Text("Keep tracking your subscriptions to generate personalized insights.")
                    .font(.system(size: 13))
                    .foregroundColor(.renewlyTextSecondary)
                    .padding(.vertical, 4)
            } else {
                VStack(spacing: 12) {
                    ForEach(insights) { item in
                        HStack(alignment: .top, spacing: 12) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .fill(item.iconColor.opacity(0.12))
                                    .frame(width: 32, height: 32)
                                
                                Image(systemName: item.icon)
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(item.iconColor)
                            }
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text(item.title)
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.renewlyTextPrimary)
                                
                                Text(item.description)
                                    .font(.system(size: 12))
                                    .foregroundColor(.renewlyTextSecondary)
                                    .lineSpacing(2)
                            }
                            
                            Spacer()
                        }
                        .padding(12)
                        .background(Color(hex: "F9F9FB"))
                        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
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
