//
//  CustomTabBar.swift
//  Renewly
//

import SwiftUI

enum AppTab: Int, CaseIterable, Identifiable {
    case home = 0
    case subs = 1
    case calendar = 2
    case insights = 3
    case more = 4
    
    var id: Int { rawValue }
    
    var title: String {
        switch self {
        case .home: return "Home"
        case .subs: return "Subs"
        case .calendar: return "Calendar"
        case .insights: return "Insights"
        case .more: return "More"
        }
    }
    
    func iconName(isSelected: Bool) -> String {
        switch self {
        case .home:
            return isSelected ? "house.fill" : "house"
        case .subs:
            return isSelected ? "rectangle.stack.fill" : "rectangle.stack"
        case .calendar:
            return isSelected ? "calendar.badge.clock" : "calendar"
        case .insights:
            return isSelected ? "chart.line.uptrend.xyaxis" : "chart.line.uptrend.xyaxis"
        case .more:
            return "ellipsis"
        }
    }
}

struct CustomTabBar: View {
    @Binding var selectedTab: AppTab
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(AppTab.allCases) { tab in
                let isSelected = selectedTab == tab
                
                Button(action: {
                    let impact = UIImpactFeedbackGenerator(style: .light)
                    impact.impactOccurred()
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.75)) {
                        selectedTab = tab
                    }
                }) {
                    VStack(spacing: 4) {
                        Image(systemName: tab.iconName(isSelected: isSelected))
                            .font(.system(size: 19, weight: isSelected ? .bold : .regular))
                            .foregroundColor(isSelected ? Color.renewlyPrimary : Color(hex: "8E8E93"))
                            .frame(height: 22)
                        
                        Text(tab.title)
                            .font(.system(size: 10, weight: isSelected ? .semibold : .medium))
                            .foregroundColor(isSelected ? Color.renewlyPrimary : Color(hex: "8E8E93"))
                    }
                    .frame(maxWidth: .infinity)
                    .contentShape(Rectangle())
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(.top, 10)
        .padding(.bottom, 2)
        .background(
            Color.white
                .shadow(color: Color.black.opacity(0.04), radius: 8, y: -2)
                .ignoresSafeArea(edges: .bottom)
        )
        .overlay(
            Rectangle()
                .fill(Color(hex: "EFEFF2"))
                .frame(height: 0.8),
            alignment: .top
        )
    }
}
