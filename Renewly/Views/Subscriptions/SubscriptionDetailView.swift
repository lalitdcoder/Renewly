//
//  SubscriptionDetailView.swift
//  Renewly
//

import SwiftUI
import SwiftData

struct SubscriptionDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Environment(\.openURL) private var openURL
    
    @Bindable var subscription: SubscriptionModel
    
    @State private var showEditSheet = false
    @State private var showChangePlanSheet = false
    @State private var showDeleteConfirmation = false
    @State private var showCancelConfirmation = false
    @State private var calendarToastMessage: String? = nil
    @State private var showCalendarToast = false
    
    private var formattedRenewalDate: String {
        if subscription.hasUnknownRenewalDate {
            return "Renewal date not set"
        }
        guard let date = subscription.nextRenewalDate else { return "Not set" }
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyyy"
        return formatter.string(from: date)
    }
    
    private var reminderText: String {
        if subscription.reminderDays.isEmpty {
            return "None"
        }
        let daysStrs = subscription.reminderDays.map { days -> String in
            if days == 0 { return "On renewal day" }
            if days == 1 { return "1 day before" }
            return "\(days) days before"
        }
        return daysStrs.joined(separator: ", ")
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 20) {
                // Header Logo, Name, Plan, Price & Badges
                VStack(spacing: 6) {
                    ServiceIconView(
                        name: subscription.name,
                        iconAssetName: subscription.iconAssetName,
                        sfSymbolName: subscription.sfSymbolName,
                        brandColorHex: subscription.brandColorHex,
                        size: 68,
                        cornerRadius: 20
                    )
                    .padding(.top, 10)
                    
                    Text(subscription.name)
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.renewlyTextPrimary)
                    
                    if let plan = subscription.effectivePlanName {
                        Text(plan)
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(.renewlyTextSecondary)
                    }
                    
                    Text(subscription.formattedPriceAndFrequency())
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.renewlyPrimary)
                    
                    if subscription.type == .trial {
                        TrialBadgeView(text: "FREE TRIAL", isUrgent: subscription.isUrgent)
                            .padding(.top, 2)
                    } else if subscription.status != .active {
                        StatusBadgeView(status: subscription.status)
                            .padding(.top, 2)
                    }
                }
                .padding(.bottom, 4)
                
                // Details Card matching Screen 06
                VStack(spacing: 0) {
                    if subscription.type == .trial {
                        DetailRow(label: "Trial ends", value: formattedRenewalDate)
                        
                        Divider().background(Color.renewlyDivider).padding(.leading, 16)
                        
                        if let postPrice = subscription.priceAfterTrial {
                            DetailRow(label: "Cost afterwards", value: String(format: "%@%.2f / month", subscription.currency, postPrice))
                            Divider().background(Color.renewlyDivider).padding(.leading, 16)
                        }
                    } else {
                        DetailRow(label: "Next renewal", value: formattedRenewalDate)
                        Divider().background(Color.renewlyDivider).padding(.leading, 16)
                    }
                    
                    // Tappable Plan Row
                    Button(action: {
                        let impact = UIImpactFeedbackGenerator(style: .light)
                        impact.impactOccurred()
                        showChangePlanSheet = true
                    }) {
                        HStack {
                            Text("Plan")
                                .font(.system(size: 14, weight: .regular))
                                .foregroundColor(.renewlyTextSecondary)
                            
                            Spacer()
                            
                            HStack(spacing: 6) {
                                Text(subscription.effectivePlanName ?? "Tap to set")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(subscription.hasPlan ? .renewlyTextPrimary : .renewlyPrimary)
                                
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 11, weight: .semibold))
                                    .foregroundColor(.renewlyTextMuted)
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 14)
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Divider().background(Color.renewlyDivider).padding(.leading, 16)
                    
                    DetailRow(label: "Reminder", value: reminderText)
                    
                    Divider().background(Color.renewlyDivider).padding(.leading, 16)
                    
                    DetailRow(label: "Category", value: subscription.categoryDisplayName)
                    
                    if !subscription.notes.isEmpty {
                        Divider().background(Color.renewlyDivider).padding(.leading, 16)
                        DetailRow(label: "Notes", value: subscription.notes)
                    }
                    
                    let trackingMonths = subscription.trackingDurationInMonths()
                    if trackingMonths > 0 {
                        Divider().background(Color.renewlyDivider).padding(.leading, 16)
                        DetailRow(label: "Tracked for", value: "\(trackingMonths) month\(trackingMonths == 1 ? "" : "s")")
                    }
                }
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .stroke(Color.renewlyCardBorder, lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(0.02), radius: 4, y: 1)
                .padding(.horizontal, 24)
                
                // Direct Management Link Card (if available)
                if let urlString = subscription.managementUrl, let url = URL(string: urlString) {
                    VStack(alignment: .leading, spacing: 6) {
                        Button(action: {
                            let impact = UIImpactFeedbackGenerator(style: .medium)
                            impact.impactOccurred()
                            openURL(url)
                        }) {
                            HStack(spacing: 12) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                                        .fill(Color.renewlyPrimaryLight)
                                        .frame(width: 36, height: 36)
                                    Image(systemName: "safari")
                                        .font(.system(size: 18, weight: .semibold))
                                        .foregroundColor(.renewlyPrimary)
                                }
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("Manage \(subscription.name)")
                                        .font(.system(size: 15, weight: .semibold))
                                        .foregroundColor(.renewlyTextPrimary)
                                    Text("Open official account & cancellation page")
                                        .font(.system(size: 12))
                                        .foregroundColor(.renewlyTextSecondary)
                                }
                                
                                Spacer()
                                
                                Image(systemName: "arrow.up.right")
                                    .font(.system(size: 13, weight: .semibold))
                                    .foregroundColor(.renewlyPrimary)
                            }
                            .padding(14)
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                            .overlay(
                                RoundedRectangle(cornerRadius: 18, style: .continuous)
                                    .stroke(Color.renewlyCardBorder, lineWidth: 1)
                            )
                            .shadow(color: Color.black.opacity(0.02), radius: 4, y: 1)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    .padding(.horizontal, 24)
                }
                
                // Actions Card matching Screen 06
                VStack(alignment: .leading, spacing: 10) {
                    Text("Actions")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.renewlyTextSecondary)
                        .padding(.horizontal, 4)
                    
                    VStack(spacing: 0) {
                        // Edit Action
                        ActionButtonRow(
                            icon: "pencil",
                            title: "Edit Details",
                            color: .renewlyTextPrimary
                        ) {
                            showEditSheet = true
                        }
                        
                        Divider().background(Color.renewlyDivider).padding(.leading, 44)
                        
                        // Add to Apple Calendar
                        if subscription.nextRenewalDate != nil && !subscription.hasUnknownRenewalDate {
                            ActionButtonRow(
                                icon: "calendar.badge.plus",
                                title: "Add to Apple Calendar",
                                color: .renewlyPrimary
                            ) {
                                Task {
                                    let result = await CalendarSyncManager.shared.addEvent(for: subscription)
                                    await MainActor.run {
                                        calendarToastMessage = result.message
                                        showCalendarToast = true
                                    }
                                }
                            }
                            
                            Divider().background(Color.renewlyDivider).padding(.leading, 44)
                        }
                        
                        // Pause / Resume Action
                        let isPaused = subscription.status == .paused
                        ActionButtonRow(
                            icon: isPaused ? "play.circle" : "pause.circle",
                            title: isPaused ? "Resume Subscription" : "Pause Subscription",
                            color: .renewlyTextPrimary
                        ) {
                            withAnimation {
                                if subscription.status == .paused {
                                    subscription.status = .active
                                    NotificationManager.shared.scheduleReminders(for: subscription)
                                } else {
                                    subscription.status = .paused
                                    NotificationManager.shared.cancelReminders(for: subscription)
                                }
                                try? modelContext.save()
                            }
                        }
                        
                        Divider().background(Color.renewlyDivider).padding(.leading, 44)
                        
                        // Mark as Cancelled / Active Action
                        let isCancelled = subscription.status == .cancelled
                        ActionButtonRow(
                            icon: isCancelled ? "arrow.counterclockwise" : "nosign",
                            title: isCancelled ? "Mark as Active" : "Mark as Cancelled",
                            color: isCancelled ? .renewlyPrimary : .renewlyAttention
                        ) {
                            if isCancelled {
                                withAnimation {
                                    subscription.status = .active
                                    NotificationManager.shared.scheduleReminders(for: subscription)
                                    try? modelContext.save()
                                }
                            } else {
                                showCancelConfirmation = true
                            }
                        }
                        
                        Divider().background(Color.renewlyDivider).padding(.leading, 44)
                        
                        // Delete Action
                        ActionButtonRow(
                            icon: "trash",
                            title: "Delete",
                            color: .renewlyAttention
                        ) {
                            showDeleteConfirmation = true
                        }
                    }
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                            .stroke(Color.renewlyCardBorder, lineWidth: 1)
                    )
                    .shadow(color: Color.black.opacity(0.02), radius: 4, y: 1)
                }
                .padding(.horizontal, 24)
            }
            .padding(.top, 8)
            .padding(.bottom, 32)
        }
        .background(Color.renewlyBackground.ignoresSafeArea())
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button(action: { showEditSheet = true }) {
                        Label("Edit", systemImage: "pencil")
                    }
                    Button(role: .destructive, action: { showDeleteConfirmation = true }) {
                        Label("Delete", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.renewlyTextPrimary)
                        .frame(width: 32, height: 32)
                }
            }
        }
        .sheet(isPresented: $showEditSheet) {
            EditSubscriptionView(subscription: subscription)
        }
        .sheet(isPresented: $showChangePlanSheet) {
            ChangePlanSheet(subscription: subscription)
        }
        .alert("Calendar Integration", isPresented: $showCalendarToast) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(calendarToastMessage ?? "")
        }
        .alert("Delete Subscription?", isPresented: $showDeleteConfirmation) {
            Button("Cancel", role: .cancel) {}
            Button("Delete", role: .destructive) {
                NotificationManager.shared.cancelReminders(for: subscription)
                modelContext.delete(subscription)
                try? modelContext.save()
                dismiss()
            }
        } message: {
            Text("This will permanently remove \(subscription.name) from your tracked subscriptions.")
        }
        .alert("Mark as Cancelled?", isPresented: $showCancelConfirmation) {
            Button("Keep Active", role: .cancel) {}
            Button("Mark Cancelled", role: .destructive) {
                withAnimation {
                    subscription.status = .cancelled
                    NotificationManager.shared.cancelReminders(for: subscription)
                    try? modelContext.save()
                }
            }
        } message: {
            Text("We will stop sending reminder notifications for \(subscription.name).")
        }
    }
}

struct DetailRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .font(.system(size: 14, weight: .regular))
                .foregroundColor(.renewlyTextSecondary)
            
            Spacer()
            
            Text(value)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.renewlyTextPrimary)
                .multilineTextAlignment(.trailing)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
    }
}

struct ActionButtonRow: View {
    let icon: String
    let title: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: {
            let impact = UIImpactFeedbackGenerator(style: .light)
            impact.impactOccurred()
            action()
        }) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 16))
                    .foregroundColor(color)
                    .frame(width: 20)
                
                Text(title)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(color)
                
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
    }
}
