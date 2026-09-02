//
//  EditSubscriptionView.swift
//  Renewly
//

import SwiftUI
import SwiftData

struct EditSubscriptionView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @Bindable var subscription: SubscriptionModel
    
    @State private var name: String = ""
    @State private var priceString: String = ""
    @State private var currency: String = "£"
    @State private var billingFrequency: BillingFrequency = .monthly
    @State private var category: SubscriptionCategory = .entertainment
    @State private var renewalDate: Date = Date()
    @State private var hasUnknownRenewalDate: Bool = false
    @State private var reminderOption: ReminderOption = .sevenDays
    @State private var customDays: Int = 7
    @State private var notes: String = ""
    @State private var status: SubscriptionStatus = .active
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Details") {
                    TextField("Name", text: $name)
                    
                    HStack {
                        Text("Price")
                        Spacer()
                        Text(currency)
                            .foregroundColor(.renewlyTextSecondary)
                        TextField("0.00", text: $priceString)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .frame(maxWidth: 90)
                    }
                    
                    Picker("Billing Frequency", selection: $billingFrequency) {
                        Text("Monthly").tag(BillingFrequency.monthly)
                        Text("Yearly").tag(BillingFrequency.yearly)
                        Text("Weekly").tag(BillingFrequency.weekly)
                    }
                    
                    Picker("Category", selection: $category) {
                        ForEach(SubscriptionCategory.allCases, id: \.self) { cat in
                            Text(cat.rawValue).tag(cat)
                        }
                    }
                    
                    Picker("Status", selection: $status) {
                        ForEach(SubscriptionStatus.allCases, id: \.self) { st in
                            Text(st.displayName).tag(st)
                        }
                    }
                }
                
                Section("Renewal Date") {
                    Toggle("I don't know renewal date", isOn: $hasUnknownRenewalDate)
                    
                    if !hasUnknownRenewalDate {
                        DatePicker("Next Renewal", selection: $renewalDate, displayedComponents: [.date])
                    }
                }
                
                Section("Reminders") {
                    Picker("Remind me", selection: $reminderOption) {
                        Text("7 days before").tag(ReminderOption.sevenDays)
                        Text("3 days before").tag(ReminderOption.threeDays)
                        Text("1 day before").tag(ReminderOption.oneDay)
                        Text("Custom").tag(ReminderOption.custom)
                    }
                    
                    if reminderOption == .custom {
                        Stepper("\(customDays) days before", value: $customDays, in: 1...60)
                    }
                }
                
                Section("Notes") {
                    TextField("Family plan, account details, etc.", text: $notes, axis: .vertical)
                        .lineLimit(3...6)
                }
            }
            .navigationTitle("Edit Subscription")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveChanges()
                        dismiss()
                    }
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.renewlyPrimary)
                }
            }
            .onAppear {
                loadCurrentValues()
            }
        }
    }
    
    private func loadCurrentValues() {
        name = subscription.name
        priceString = String(format: "%.2f", subscription.price)
        currency = subscription.currency
        billingFrequency = subscription.billingFrequency
        category = subscription.category
        status = subscription.status
        notes = subscription.notes
        hasUnknownRenewalDate = subscription.hasUnknownRenewalDate
        if let nextDate = subscription.nextRenewalDate {
            renewalDate = nextDate
        }
        if let firstReminder = subscription.reminderDays.first {
            if firstReminder == 7 {
                reminderOption = .sevenDays
            } else if firstReminder == 3 {
                reminderOption = .threeDays
            } else if firstReminder == 1 {
                reminderOption = .oneDay
            } else {
                reminderOption = .custom
                customDays = firstReminder
            }
        }
    }
    
    private func saveChanges() {
        subscription.name = name.trimmingCharacters(in: .whitespaces).isEmpty ? subscription.name : name
        subscription.price = Double(priceString.replacingOccurrences(of: ",", with: ".")) ?? subscription.price
        subscription.billingFrequency = billingFrequency
        subscription.category = category
        subscription.status = status
        subscription.notes = notes
        subscription.hasUnknownRenewalDate = hasUnknownRenewalDate
        subscription.nextRenewalDate = hasUnknownRenewalDate ? nil : renewalDate
        subscription.updatedAt = Date()
        
        switch reminderOption {
        case .sevenDays: subscription.reminderDays = [7]
        case .threeDays: subscription.reminderDays = [3]
        case .oneDay: subscription.reminderDays = [1]
        case .custom: subscription.reminderDays = [customDays]
        }
        
        try? modelContext.save()
        NotificationManager.shared.scheduleReminders(for: subscription)
    }
}
