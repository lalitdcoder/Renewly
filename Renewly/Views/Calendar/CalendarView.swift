//
//  CalendarView.swift
//  Renewly
//

import SwiftUI
import SwiftData

struct CalendarView: View {
    @Query private var subscriptions: [SubscriptionModel]
    
    @State private var selectedDate: Date = Date()
    @State private var displayedMonth: Date = Date()
    
    private let calendar = Calendar.current
    
    private var monthYearFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }
    
    private var dayFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d"
        return formatter
    }
    
    private var activeSubscriptions: [SubscriptionModel] {
        subscriptions.filter { $0.status == .active && $0.nextRenewalDate != nil && !$0.hasUnknownRenewalDate }
    }
    
    private var eventsForSelectedDate: [SubscriptionModel] {
        let startOfSelected = calendar.startOfDay(for: selectedDate)
        return activeSubscriptions.filter { sub in
            guard let renewal = sub.nextRenewalDate else { return false }
            return calendar.isDate(renewal, inSameDayAs: startOfSelected)
        }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {
                    // Month Selector Header (< September 2026 >)
                    HStack {
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                displayedMonth = calendar.date(byAdding: .month, value: -1, to: displayedMonth) ?? displayedMonth
                            }
                        }) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 15, weight: .bold))
                                .foregroundColor(.renewlyTextPrimary)
                                .frame(width: 36, height: 36)
                        }
                        
                        Spacer()
                        
                        Text(monthYearFormatter.string(from: displayedMonth))
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.renewlyTextPrimary)
                        
                        Spacer()
                        
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                displayedMonth = calendar.date(byAdding: .month, value: 1, to: displayedMonth) ?? displayedMonth
                            }
                        }) {
                            Image(systemName: "chevron.right")
                                .font(.system(size: 15, weight: .bold))
                                .foregroundColor(.renewlyTextPrimary)
                                .frame(width: 36, height: 36)
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 12)
                    
                    // Monthly Calendar Card
                    VStack(spacing: 12) {
                        // Weekday symbols
                        let symbols = ["M", "T", "W", "T", "F", "S", "S"]
                        HStack(spacing: 0) {
                            ForEach(0..<7, id: \.self) { i in
                                Text(symbols[i])
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(.renewlyTextMuted)
                                    .frame(maxWidth: .infinity)
                            }
                        }
                        .padding(.horizontal, 8)
                        
                        // Days Grid
                        let days = daysInMonth(for: displayedMonth)
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 4), count: 7), spacing: 6) {
                            ForEach(days, id: \.self) { date in
                                if let date = date {
                                    let isSelected = calendar.isDate(date, inSameDayAs: selectedDate)
                                    let isToday = calendar.isDateInToday(date)
                                    let events = eventsForDate(date)
                                    let hasRenewal = events.contains { $0.type == .subscription }
                                    let hasTrial = events.contains { $0.type == .trial }
                                    
                                    Button(action: {
                                        let impact = UIImpactFeedbackGenerator(style: .light)
                                        impact.impactOccurred()
                                        withAnimation(.spring(response: 0.25, dampingFraction: 0.75)) {
                                            selectedDate = date
                                        }
                                    }) {
                                        VStack(spacing: 3) {
                                            Text("\(calendar.component(.day, from: date))")
                                                .font(.system(size: 14, weight: isSelected || isToday ? .bold : .medium))
                                                .foregroundColor(isSelected ? .white : (isToday ? .renewlyPrimary : .renewlyTextPrimary))
                                            
                                            // Event Indicator Dots
                                            HStack(spacing: 3) {
                                                if hasRenewal {
                                                    Circle()
                                                        .fill(isSelected ? Color.white : Color.renewlyPrimary)
                                                        .frame(width: 4, height: 4)
                                                }
                                                if hasTrial {
                                                    Circle()
                                                        .fill(isSelected ? Color.white : Color.renewlyAttention)
                                                        .frame(width: 4, height: 4)
                                                }
                                            }
                                            .frame(height: 4)
                                        }
                                        .frame(height: 38)
                                        .frame(maxWidth: .infinity)
                                        .background(
                                            isSelected ?
                                            RoundedRectangle(cornerRadius: 12, style: .continuous).fill(Color.renewlyPrimary) :
                                                (isToday ? RoundedRectangle(cornerRadius: 12, style: .continuous).fill(Color.renewlyPrimaryLight) : nil)
                                        )
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                } else {
                                    Color.clear
                                        .frame(height: 38)
                                }
                            }
                        }
                        .padding(.horizontal, 4)
                    }
                    .padding(16)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .stroke(Color.renewlyCardBorder, lineWidth: 1)
                    )
                    .shadow(color: Color.black.opacity(0.02), radius: 4, y: 1)
                    .padding(.horizontal, 24)
                    
                    // Selected Date Events Section
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text(dayFormatter.string(from: selectedDate))
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.renewlyTextPrimary)
                            
                            Spacer()
                            
                            if !eventsForSelectedDate.isEmpty {
                                Text("\(eventsForSelectedDate.count) event\(eventsForSelectedDate.count == 1 ? "" : "s")")
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(.renewlyTextSecondary)
                            }
                        }
                        
                        if eventsForSelectedDate.isEmpty {
                            HStack(spacing: 10) {
                                Text("🎉")
                                    .font(.system(size: 20))
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("No events on this day")
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(.renewlyTextPrimary)
                                    Text("You're all caught up! No upcoming renewal charges or expiring trials.")
                                        .font(.system(size: 12))
                                        .foregroundColor(.renewlyTextSecondary)
                                }
                            }
                            .padding(16)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                            .overlay(
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .stroke(Color.renewlyCardBorder, lineWidth: 1)
                            )
                        } else {
                            VStack(spacing: 8) {
                                ForEach(eventsForSelectedDate) { sub in
                                    HStack(spacing: 12) {
                                        ServiceIconView(
                                            name: sub.name,
                                            iconAssetName: sub.iconAssetName,
                                            sfSymbolName: sub.sfSymbolName,
                                            brandColorHex: sub.brandColorHex,
                                            size: 42
                                        )
                                        
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(sub.name)
                                                .font(.system(size: 15, weight: .bold))
                                                .foregroundColor(.renewlyTextPrimary)
                                            
                                            HStack(spacing: 4) {
                                                if sub.type == .trial {
                                                    TrialBadgeView(text: "Trial Ends", isUrgent: true)
                                                } else {
                                                    HStack(spacing: 3) {
                                                        Image(systemName: "arrow.clockwise")
                                                            .font(.system(size: 10, weight: .bold))
                                                        Text("Renewal")
                                                            .font(.system(size: 11, weight: .semibold))
                                                    }
                                                    .foregroundColor(.renewlyPrimary)
                                                    .padding(.horizontal, 6)
                                                    .padding(.vertical, 2)
                                                    .background(Color.renewlyPrimaryLight)
                                                    .clipShape(Capsule())
                                                }
                                            }
                                        }
                                        
                                        Spacer()
                                        
                                        VStack(alignment: .trailing, spacing: 2) {
                                            Text(sub.type == .trial ? (sub.priceAfterTrial.map { String(format: "%@%.2f", sub.currency, $0) } ?? "Free") : String(format: "%@%.2f", sub.currency, sub.price))
                                                .font(.system(size: 16, weight: .bold, design: .rounded))
                                                .foregroundColor(.renewlyTextPrimary)
                                            
                                            if sub.type == .trial {
                                                Text("/mo afterwards")
                                                    .font(.system(size: 10, weight: .regular))
                                                    .foregroundColor(.renewlyTextMuted)
                                            }
                                        }
                                    }
                                    .padding(14)
                                    .background(Color.white)
                                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                                            .stroke(sub.type == .trial ? Color.renewlyAttentionBorder.opacity(0.8) : Color.renewlyCardBorder, lineWidth: 1)
                                    )
                                    .shadow(color: Color.black.opacity(0.02), radius: 3, y: 1)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 4)
                    .padding(.bottom, 24)
                }
            }
            .background(Color.renewlyBackground.ignoresSafeArea())
            .navigationTitle("Calendar")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private func daysInMonth(for monthDate: Date) -> [Date?] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: monthDate),
              let monthFirstWeek = calendar.dateInterval(of: .weekOfMonth, for: monthInterval.start) else {
            return []
        }
        
        var days: [Date?] = []
        var currentDate = monthFirstWeek.start
        
        while currentDate < monthInterval.end || days.count % 7 != 0 {
            if calendar.isDate(currentDate, equalTo: monthDate, toGranularity: .month) {
                days.append(currentDate)
            } else {
                days.append(nil)
            }
            guard let next = calendar.date(byAdding: .day, value: 1, to: currentDate) else { break }
            currentDate = next
            if days.count > 42 { break }
        }
        
        return days
    }
    
    private func eventsForDate(_ date: Date) -> [SubscriptionModel] {
        activeSubscriptions.filter { sub in
            guard let renewal = sub.nextRenewalDate else { return false }
            return calendar.isDate(renewal, inSameDayAs: date)
        }
    }
}
