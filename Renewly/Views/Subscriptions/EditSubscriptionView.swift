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
    @State private var planName: String = ""
    @State private var priceString: String = ""
    @State private var currency: String = "£"
    @State private var billingFrequency: BillingFrequency = .monthly
    @State private var selectedCategoryName: String = "Entertainment"
    @State private var renewalDate: Date = Date()
    @State private var hasUnknownRenewalDate: Bool = false
    @State private var reminderDaysSelection: [Int] = [7]
    @State private var notes: String = ""
    @State private var managementUrlString: String = ""
    @State private var priceAfterTrialString: String = ""
    @State private var status: SubscriptionStatus = .active
    
    private let availableReminderDays = [14, 7, 3, 1, 0]
    
    private var availablePlans: [ServicePlan] {
        ServicePreset.plans(for: name.isEmpty ? subscription.name : name)
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Details") {
                    TextField("Name", text: $name)
                    
                    if subscription.type == .subscription {
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
                    } else {
                        HStack {
                            Text("Cost Afterwards")
                            Spacer()
                            Text(currency)
                                .foregroundColor(.renewlyTextSecondary)
                            TextField("0.00", text: $priceAfterTrialString)
                                .keyboardType(.decimalPad)
                                .multilineTextAlignment(.trailing)
                                .frame(maxWidth: 90)
                        }
                    }
                    
                    Picker("Category", selection: $selectedCategoryName) {
                        ForEach(CategoryManager.shared.allCategories) { cat in
                            HStack {
                                Image(systemName: cat.sfSymbolName)
                                Text(cat.name)
                            }
                            .tag(cat.name)
                        }
                    }
                    
                    Picker("Status", selection: $status) {
                        ForEach(SubscriptionStatus.allCases, id: \.self) { st in
                            Text(st.displayName).tag(st)
                        }
                    }
                }
                
                Section("Plan / Tier") {
                    if !availablePlans.isEmpty {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ForEach(availablePlans) { plan in
                                    let isSelected = planName == plan.name
                                    Button(action: {
                                        planName = plan.name
                                        if subscription.type == .subscription {
                                            priceString = String(format: "%.2f", plan.defaultPrice)
                                            billingFrequency = plan.billingFrequency
                                        } else {
                                            priceAfterTrialString = String(format: "%.2f", plan.defaultPrice)
                                        }
                                    }) {
                                        Text(plan.name)
                                            .font(.system(size: 13, weight: .medium))
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 6)
                                            .background(isSelected ? Color.renewlyPrimary : Color.renewlyCardBorder.opacity(0.4))
                                            .foregroundColor(isSelected ? .white : .renewlyTextPrimary)
                                            .clipShape(Capsule())
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            .padding(.vertical, 2)
                        }
                    }
                    
                    TextField("e.g. Premium, 200 GB, Family, Student", text: $planName)
                }
                
                Section(subscription.type == .trial ? "Trial End Date" : "Renewal Date") {
                    Toggle("I don't know the exact date", isOn: $hasUnknownRenewalDate)
                    
                    if !hasUnknownRenewalDate {
                        DatePicker(subscription.type == .trial ? "Trial Ends" : "Next Renewal", selection: $renewalDate, displayedComponents: [.date])
                    }
                }
                
                Section("Reminders") {
                    ForEach(availableReminderDays, id: \.self) { days in
                        let isSelected = reminderDaysSelection.contains(days)
                        Button(action: {
                            if isSelected {
                                reminderDaysSelection.removeAll { $0 == days }
                            } else {
                                reminderDaysSelection.append(days)
                            }
                        }) {
                            HStack {
                                Text(reminderLabel(for: days))
                                    .foregroundColor(.renewlyTextPrimary)
                                Spacer()
                                if isSelected {
                                    Image(systemName: "checkmark")
                                        .font(.system(size: 14, weight: .bold))
                                        .foregroundColor(.renewlyPrimary)
                                }
                            }
                        }
                    }
                }
                
                Section("Management & Cancellation Link") {
                    TextField("https://...", text: $managementUrlString)
                        .keyboardType(.URL)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                }
                
                Section("Notes") {
                    TextField("Plan type, account email, etc.", text: $notes, axis: .vertical)
                        .lineLimit(3...6)
                }
            }
            .navigationTitle(subscription.type == .trial ? "Edit Free Trial" : "Edit Subscription")
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
    
    private func reminderLabel(for days: Int) -> String {
        if days == 0 { return "On renewal day" }
        if days == 1 { return "1 day before" }
        return "\(days) days before"
    }
    
    private func loadCurrentValues() {
        name = subscription.name
        planName = subscription.planName ?? ""
        priceString = String(format: "%.2f", subscription.price)
        currency = subscription.currency
        billingFrequency = subscription.billingFrequency
        selectedCategoryName = subscription.categoryRaw
        status = subscription.status
        notes = subscription.notes
        managementUrlString = subscription.managementUrl ?? ""
        if let post = subscription.priceAfterTrial {
            priceAfterTrialString = String(format: "%.2f", post)
        }
        hasUnknownRenewalDate = subscription.hasUnknownRenewalDate
        if let nextDate = subscription.nextRenewalDate {
            renewalDate = nextDate
        }
        reminderDaysSelection = subscription.reminderDays.isEmpty ? [7] : subscription.reminderDays
    }
    
    private func saveChanges() {
        subscription.name = name.trimmingCharacters(in: .whitespaces).isEmpty ? subscription.name : name
        let trimmedPlan = planName.trimmingCharacters(in: .whitespacesAndNewlines)
        subscription.planName = trimmedPlan.isEmpty ? nil : trimmedPlan
        subscription.price = Double(priceString.replacingOccurrences(of: ",", with: ".")) ?? subscription.price
        if let postVal = Double(priceAfterTrialString.replacingOccurrences(of: ",", with: ".")) {
            subscription.priceAfterTrial = postVal
        }
        subscription.billingFrequency = billingFrequency
        subscription.categoryRaw = selectedCategoryName
        if let knownCat = SubscriptionCategory(rawValue: selectedCategoryName) {
            subscription.category = knownCat
        } else {
            subscription.category = .other
        }
        subscription.status = status
        subscription.notes = notes
        let trimmedUrl = managementUrlString.trimmingCharacters(in: .whitespacesAndNewlines)
        subscription.managementUrl = trimmedUrl.isEmpty ? nil : trimmedUrl
        subscription.hasUnknownRenewalDate = hasUnknownRenewalDate
        subscription.nextRenewalDate = hasUnknownRenewalDate ? nil : renewalDate
        subscription.reminderDays = reminderDaysSelection.isEmpty ? [1, 0] : reminderDaysSelection
        subscription.updatedAt = Date()
        
        try? modelContext.save()
        NotificationManager.shared.scheduleReminders(for: subscription)
    }
}
