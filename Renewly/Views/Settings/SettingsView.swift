//
//  SettingsView.swift
//  Renewly
//

import SwiftUI
import SwiftData

struct SettingsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var subscriptions: [SubscriptionModel]
    
    @State private var userPreferences = UserPreferences.shared
    
    @State private var showHelpSheet = false
    @State private var showCurrencySheet = false
    @State private var showCategorySheet = false
    @State private var showWidgetsSheet = false
    @State private var showExportShareSheet = false
    @State private var exportFileURL: URL?
    @State private var showResetConfirmation = false
    @State private var showClearConfirmation = false
    @State private var calendarToastMessage: String? = nil
    @State private var showCalendarToast = false
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    // Header
                    HStack {
                        Text("More")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.renewlyTextPrimary)
                        Spacer()
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 12)
                    
                    // Group 1: Notifications
                    SettingsGroupCard(title: "Notifications") {
                        VStack(spacing: 0) {
                            SettingsToggleRow(
                                icon: "bell.fill",
                                iconColor: Color(hex: "6354EC"),
                                title: "Renewal Reminders",
                                subtitle: "Get alerts before subscriptions renew",
                                isOn: $userPreferences.renewalRemindersEnabled
                            )
                            
                            Divider().background(Color.renewlyDivider).padding(.leading, 56)
                            
                            SettingsToggleRow(
                                icon: "gift.fill",
                                iconColor: Color.renewlyTrialAmber,
                                title: "Trial Reminders",
                                subtitle: "Get alerts before free trials end",
                                isOn: $userPreferences.trialRemindersEnabled
                            )
                            
                            Divider().background(Color.renewlyDivider).padding(.leading, 56)
                            
                            HStack(spacing: 14) {
                                SettingsIconBadge(icon: "clock.fill", color: Color(hex: "34C759"))
                                
                                Text("Default Reminder Time")
                                    .font(.system(size: 15, weight: .medium))
                                    .foregroundColor(.renewlyTextPrimary)
                                
                                Spacer()
                                
                                DatePicker(
                                    "",
                                    selection: $userPreferences.defaultReminderTime,
                                    displayedComponents: .hourAndMinute
                                )
                                .labelsHidden()
                                .tint(Color.renewlyPrimary)
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                        }
                    }
                    
                    // Group 2: Preferences & Customization
                    SettingsGroupCard(title: "Preferences") {
                        VStack(spacing: 0) {
                            // Currency Row
                            SettingsNavigationRow(
                                icon: "banknote.fill",
                                iconColor: Color(hex: "007AFF"),
                                title: "Currency",
                                value: "\(userPreferences.currency.name)"
                            ) {
                                showCurrencySheet = true
                            }
                            
                            Divider().background(Color.renewlyDivider).padding(.leading, 56)
                            
                            // Custom Categories Row
                            SettingsNavigationRow(
                                icon: "tag.fill",
                                iconColor: Color(hex: "9B51E0"),
                                title: "Custom Categories",
                                value: "\(CategoryManager.shared.allCategories.count)"
                            ) {
                                showCategorySheet = true
                            }
                            
                            Divider().background(Color.renewlyDivider).padding(.leading, 56)
                            
                            // Home Screen Widgets Row
                            SettingsNavigationRow(
                                icon: "rectangle.3.group.fill",
                                iconColor: Color(hex: "6354EC"),
                                title: "Home Screen Widgets",
                                value: "Preview"
                            ) {
                                showWidgetsSheet = true
                            }
                            
                            Divider().background(Color.renewlyDivider).padding(.leading, 56)
                            
                            // Appearance Row
                            HStack(spacing: 14) {
                                SettingsIconBadge(icon: "paintbrush.fill", color: Color(hex: "AF52DE"))
                                
                                Text("Appearance")
                                    .font(.system(size: 15, weight: .medium))
                                    .foregroundColor(.renewlyTextPrimary)
                                
                                Spacer()
                                
                                Picker("", selection: $userPreferences.appearance) {
                                    ForEach(AppAppearance.allCases) { app in
                                        Text(app.displayName).tag(app)
                                    }
                                }
                                .pickerStyle(.segmented)
                                .frame(maxWidth: 180)
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                            
                            Divider().background(Color.renewlyDivider).padding(.leading, 56)
                            
                            // Start of Week Row
                            HStack(spacing: 14) {
                                SettingsIconBadge(icon: "calendar", color: Color(hex: "FF9500"))
                                
                                Text("Start of Week")
                                    .font(.system(size: 15, weight: .medium))
                                    .foregroundColor(.renewlyTextPrimary)
                                
                                Spacer()
                                
                                Picker("", selection: $userPreferences.weekStart) {
                                    ForEach(WeekStartDay.allCases) { wk in
                                        Text(wk.displayName).tag(wk)
                                    }
                                }
                                .pickerStyle(.menu)
                                .tint(Color.renewlyPrimary)
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                        }
                    }
                    
                    // Group 3: Integrations & Calendar
                    SettingsGroupCard(title: "Calendar Integration") {
                        VStack(spacing: 0) {
                            SettingsButtonRow(
                                icon: "calendar.badge.plus",
                                iconColor: Color(hex: "E50914"),
                                title: "Sync Renewals to Apple Calendar",
                                color: .renewlyPrimary
                            ) {
                                Task {
                                    let result = await CalendarSyncManager.shared.syncAllEvents(subscriptions: subscriptions)
                                    await MainActor.run {
                                        calendarToastMessage = result.message
                                        showCalendarToast = true
                                    }
                                }
                            }
                        }
                    }
                    
                    // Group 3: Data & Backup
                    SettingsGroupCard(title: "Data & Backup") {
                        VStack(spacing: 0) {
                            SettingsButtonRow(
                                icon: "square.and.arrow.up.fill",
                                iconColor: Color(hex: "5856D6"),
                                title: "Export Data (JSON)",
                                color: .renewlyTextPrimary
                            ) {
                                exportJSON()
                            }
                            
                            Divider().background(Color.renewlyDivider).padding(.leading, 56)
                            
                            SettingsButtonRow(
                                icon: "tablecells.fill",
                                iconColor: Color(hex: "34C759"),
                                title: "Export Data (CSV)",
                                color: .renewlyTextPrimary
                            ) {
                                exportCSV()
                            }
                            
                            Divider().background(Color.renewlyDivider).padding(.leading, 56)
                            
                            SettingsButtonRow(
                                icon: "arrow.counterclockwise.circle.fill",
                                iconColor: Color.renewlyPrimary,
                                title: "Reset Demo Subscriptions",
                                color: .renewlyPrimary
                            ) {
                                showResetConfirmation = true
                            }
                            
                            Divider().background(Color.renewlyDivider).padding(.leading, 56)
                            
                            SettingsButtonRow(
                                icon: "trash.fill",
                                iconColor: Color.renewlyAttention,
                                title: "Clear All Subscriptions",
                                color: .renewlyAttention
                            ) {
                                showClearConfirmation = true
                            }
                        }
                    }
                    
                    // Group 4: About
                    SettingsGroupCard(title: "About") {
                        VStack(spacing: 0) {
                            SettingsNavigationRow(
                                icon: "questionmark.circle.fill",
                                iconColor: Color(hex: "00C7BE"),
                                title: "Help & FAQ",
                                value: ""
                            ) {
                                showHelpSheet = true
                            }
                            
                            Divider().background(Color.renewlyDivider).padding(.leading, 56)
                            
                            HStack(spacing: 14) {
                                SettingsIconBadge(icon: "info.circle.fill", color: Color(hex: "8E8E93"))
                                
                                Text("Version")
                                    .font(.system(size: 15, weight: .medium))
                                    .foregroundColor(.renewlyTextPrimary)
                                
                                Spacer()
                                
                                Text("1.0.0 (Build 1)")
                                    .font(.system(size: 14))
                                    .foregroundColor(.renewlyTextSecondary)
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 14)
                        }
                    }
                }
                .padding(.bottom, 32)
            }
            .background(Color.renewlyBackground.ignoresSafeArea())
            .sheet(isPresented: $showHelpSheet) {
                AboutHelpView()
            }
            .sheet(isPresented: $showCurrencySheet) {
                CurrencyPickerSheet(selectedCurrency: $userPreferences.currency)
            }
            .sheet(isPresented: $showCategorySheet) {
                CategoryManagementSheet()
            }
            .sheet(isPresented: $showWidgetsSheet) {
                WidgetPreviewView()
            }
            .sheet(isPresented: $showExportShareSheet) {
                if let url = exportFileURL {
                    ShareSheet(activityItems: [url])
                }
            }
            .alert("Calendar Integration", isPresented: $showCalendarToast) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(calendarToastMessage ?? "")
            }
            .alert("Reset Demo Data?", isPresented: $showResetConfirmation) {
                Button("Cancel", role: .cancel) {}
                Button("Reset", role: .destructive) {
                    SampleDataLoader.resetToSampleData(modelContext: modelContext)
                }
            } message: {
                Text("This will replace current items with the default demo subscriptions (Netflix, Spotify, iCloud, etc.).")
            }
            .alert("Clear All Subscriptions?", isPresented: $showClearConfirmation) {
                Button("Cancel", role: .cancel) {}
                Button("Delete All", role: .destructive) {
                    NotificationManager.shared.cancelAllReminders()
                    for sub in subscriptions {
                        modelContext.delete(sub)
                    }
                    try? modelContext.save()
                }
            } message: {
                Text("This will permanently delete all your subscriptions and cancel all scheduled reminders.")
            }
        }
    }
    
    private func exportJSON() {
        guard let data = DataExportManager.exportToJSON(subscriptions: subscriptions) else { return }
        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent("Renewly_Backup.json")
        try? data.write(to: tempURL)
        exportFileURL = tempURL
        showExportShareSheet = true
    }
    
    private func exportCSV() {
        let csv = DataExportManager.exportToCSV(subscriptions: subscriptions)
        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent("Renewly_Subscriptions.csv")
        try? csv.data(using: .utf8)?.write(to: tempURL)
        exportFileURL = tempURL
        showExportShareSheet = true
    }
}

// MARK: - Reusable Settings Components
struct SettingsGroupCard<Content: View>: View {
    let title: String
    @ViewBuilder let content: () -> Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(.renewlyTextSecondary)
                .textCase(.uppercase)
                .padding(.horizontal, 28)
            
            VStack(spacing: 0) {
                content()
            }
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .stroke(Color.renewlyCardBorder, lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.02), radius: 4, y: 1)
            .padding(.horizontal, 24)
        }
    }
}

struct SettingsIconBadge: View {
    let icon: String
    let color: Color
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .fill(color)
                .frame(width: 28, height: 28)
            
            Image(systemName: icon)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.white)
        }
    }
}

struct SettingsNavigationRow: View {
    let icon: String
    let iconColor: Color
    let title: String
    let value: String
    let action: () -> Void
    
    var body: some View {
        Button(action: {
            let impact = UIImpactFeedbackGenerator(style: .light)
            impact.impactOccurred()
            action()
        }) {
            HStack(spacing: 14) {
                SettingsIconBadge(icon: icon, color: iconColor)
                
                Text(title)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(.renewlyTextPrimary)
                
                Spacer()
                
                if !value.isEmpty {
                    Text(value)
                        .font(.system(size: 14))
                        .foregroundColor(.renewlyTextSecondary)
                }
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.renewlyTextMuted)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct SettingsToggleRow: View {
    let icon: String
    let iconColor: Color
    let title: String
    var subtitle: String? = nil
    @Binding var isOn: Bool
    
    var body: some View {
        HStack(spacing: 14) {
            SettingsIconBadge(icon: icon, color: iconColor)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(.renewlyTextPrimary)
                
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(.system(size: 12))
                        .foregroundColor(.renewlyTextSecondary)
                }
            }
            
            Spacer()
            
            Toggle("", isOn: $isOn)
                .labelsHidden()
                .tint(Color.renewlyPrimary)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
}

struct SettingsButtonRow: View {
    let icon: String
    let iconColor: Color
    let title: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: {
            let impact = UIImpactFeedbackGenerator(style: .light)
            impact.impactOccurred()
            action()
        }) {
            HStack(spacing: 14) {
                SettingsIconBadge(icon: icon, color: iconColor)
                
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

// MARK: - Currency Picker Sheet
struct CurrencyPickerSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedCurrency: CurrencyOption
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(CurrencyOption.allCases) { curr in
                    Button(action: {
                        selectedCurrency = curr
                        dismiss()
                    }) {
                        HStack {
                            Text(curr.rawValue)
                                .font(.system(size: 20, weight: .bold, design: .rounded))
                                .frame(width: 44, alignment: .leading)
                                .foregroundColor(.renewlyPrimary)
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text(curr.name)
                                    .font(.system(size: 15, weight: .medium))
                                    .foregroundColor(.renewlyTextPrimary)
                                Text(curr.code)
                                    .font(.system(size: 12))
                                    .foregroundColor(.renewlyTextSecondary)
                            }
                            
                            Spacer()
                            
                            if selectedCurrency == curr {
                                Image(systemName: "checkmark")
                                    .font(.system(size: 15, weight: .bold))
                                    .foregroundColor(.renewlyPrimary)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .navigationTitle("Select Currency")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

// MARK: - Share Sheet Helper
struct ShareSheet: UIViewControllerRepresentable {
    let activityItems: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
