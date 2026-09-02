//
//  QuickAddSubscriptionSheet.swift
//  Renewly
//

import SwiftUI
import SwiftData

struct QuickAddSubscriptionSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    let onSwitchToDetailedAdd: () -> Void
    
    @State private var selectedPreset: ServicePreset? = nil
    @State private var customServiceName = ""
    @State private var showCustomServiceInput = false
    
    // Quick Form fields
    @State private var priceString: String = ""
    @State private var billingFrequency: BillingFrequency = .monthly
    @State private var renewalDate: Date = Date()
    @State private var hasUnknownRenewalDate: Bool = false
    @State private var isTrial: Bool = false
    @State private var priceAfterTrialString: String = "12.99"
    
    // Success / Multi-add loop state
    @State private var justAddedSubscription: SubscriptionModel? = nil
    @State private var searchText = ""
    
    private var filteredPresets: [ServicePreset] {
        if searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return ServicePreset.allPresets
        }
        return ServicePreset.allPresets.filter {
            $0.name.localizedCaseInsensitiveContains(searchText) ||
            $0.category.rawValue.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    var body: some View {
        NavigationStack {
            Group {
                if let added = justAddedSubscription {
                    // Multi-add loop success state
                    addedSuccessView(addedSub: added)
                } else if let preset = selectedPreset {
                    // Quick Single-Screen Form
                    quickFormView(preset: preset)
                } else {
                    // Service Selector
                    servicePickerView
                }
            }
            .background(Color.renewlyBackground.ignoresSafeArea())
            .navigationTitle(selectedPreset == nil ? "Quick Add" : (selectedPreset?.name ?? "Add Subscription"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.renewlyTextSecondary)
                }
                
                if selectedPreset == nil && justAddedSubscription == nil {
                    ToolbarItem(placement: .primaryAction) {
                        Button("Detailed Add") {
                            onSwitchToDetailedAdd()
                        }
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.renewlyPrimary)
                    }
                }
            }
        }
    }
    
    // MARK: - Service Picker
    private var servicePickerView: some View {
        VStack(spacing: 0) {
            // Search Input
            HStack(spacing: 10) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.renewlyTextMuted)
                TextField("Search service (e.g. Netflix, Spotify)", text: $searchText)
                    .font(.system(size: 15))
                if !searchText.isEmpty {
                    Button(action: { searchText = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.renewlyTextMuted)
                    }
                }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .stroke(Color.renewlyCardBorder, lineWidth: 1)
            )
            .padding(.horizontal, 20)
            .padding(.top, 12)
            .padding(.bottom, 12)
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 14) {
                    if filteredPresets.isEmpty {
                        VStack(spacing: 14) {
                            Text("Can't find \"\(searchText)\"?")
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(.renewlyTextPrimary)
                            
                            Button(action: {
                                selectCustomPreset(name: searchText)
                            }) {
                                HStack(spacing: 6) {
                                    Image(systemName: "plus.circle.fill")
                                    Text("Add \"\(searchText)\"")
                                }
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.renewlyPrimary)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 10)
                                .background(Color.renewlyPrimaryLight)
                                .clipShape(Capsule())
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 32)
                    } else {
                        HStack {
                            Text("Popular Services")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(.renewlyTextSecondary)
                                .textCase(.uppercase)
                            Spacer()
                        }
                        .padding(.horizontal, 20)
                        
                        LazyVGrid(columns: [GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10)], spacing: 10) {
                            ForEach(filteredPresets) { preset in
                                Button(action: {
                                    selectPreset(preset)
                                }) {
                                    HStack(spacing: 10) {
                                        ServiceIconView(
                                            name: preset.name,
                                            iconAssetName: preset.iconAssetName,
                                            sfSymbolName: preset.sfSymbolName,
                                            brandColorHex: preset.brandColorHex,
                                            size: 36,
                                            cornerRadius: 10
                                        )
                                        
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(preset.name)
                                                .font(.system(size: 14, weight: .bold))
                                                .foregroundColor(.renewlyTextPrimary)
                                                .lineLimit(1)
                                            
                                            Text(String(format: "%@%.2f", UserPreferences.shared.currency.rawValue, preset.defaultPrice))
                                                .font(.system(size: 11, weight: .medium))
                                                .foregroundColor(.renewlyTextSecondary)
                                        }
                                        
                                        Spacer()
                                    }
                                    .padding(10)
                                    .background(Color.white)
                                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                                            .stroke(Color.renewlyCardBorder, lineWidth: 1)
                                    )
                                    .shadow(color: Color.black.opacity(0.02), radius: 2, y: 1)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        // Custom service button
                        Button(action: {
                            showCustomServiceInput = true
                        }) {
                            HStack {
                                Image(systemName: "plus")
                                Text("Add Custom Service")
                            }
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.renewlyPrimary)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                            .overlay(
                                RoundedRectangle(cornerRadius: 14, style: .continuous)
                                    .stroke(Color.renewlyCardBorder, lineWidth: 1)
                            )
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 4)
                    }
                }
                .padding(.bottom, 24)
            }
        }
        .alert("Custom Service", isPresented: $showCustomServiceInput) {
            TextField("Service Name (e.g. Gym, VPN)", text: $customServiceName)
            Button("Cancel", role: .cancel) {}
            Button("Next") {
                let trimmed = customServiceName.trimmingCharacters(in: .whitespacesAndNewlines)
                if !trimmed.isEmpty {
                    selectCustomPreset(name: trimmed)
                }
            }
        }
    }
    
    // MARK: - Quick Form
    private func quickFormView(preset: ServicePreset) -> some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 18) {
                // Service Header Card
                HStack(spacing: 12) {
                    ServiceIconView(
                        name: preset.name,
                        iconAssetName: preset.iconAssetName,
                        sfSymbolName: preset.sfSymbolName,
                        brandColorHex: preset.brandColorHex,
                        size: 48,
                        cornerRadius: 14
                    )
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(preset.name)
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.renewlyTextPrimary)
                        Text(preset.category.rawValue)
                            .font(.system(size: 13))
                            .foregroundColor(.renewlyTextSecondary)
                    }
                    
                    Spacer()
                    
                    Button("Change") {
                        selectedPreset = nil
                    }
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.renewlyPrimary)
                }
                .padding(14)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(Color.renewlyCardBorder, lineWidth: 1)
                )
                
                // Price Input
                VStack(alignment: .leading, spacing: 6) {
                    Text("How much does it cost?")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.renewlyTextSecondary)
                    
                    HStack(spacing: 8) {
                        Text(UserPreferences.shared.currency.rawValue)
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                            .foregroundColor(.renewlyTextSecondary)
                        
                        TextField("0.00", text: $priceString)
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                            .foregroundColor(.renewlyTextPrimary)
                            .keyboardType(.decimalPad)
                    }
                    .padding(14)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .stroke(Color.renewlyCardBorder, lineWidth: 1)
                    )
                }
                
                // Frequency
                VStack(alignment: .leading, spacing: 6) {
                    Text("Billing Frequency")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.renewlyTextSecondary)
                    
                    HStack(spacing: 8) {
                        BillingPill(title: "Monthly", isSelected: billingFrequency == .monthly) {
                            billingFrequency = .monthly
                        }
                        BillingPill(title: "Yearly", isSelected: billingFrequency == .yearly) {
                            billingFrequency = .yearly
                        }
                        BillingPill(title: "Weekly", isSelected: billingFrequency == .weekly) {
                            billingFrequency = .weekly
                        }
                    }
                }
                
                // Renewal Date
                VStack(alignment: .leading, spacing: 6) {
                    Text("When does it renew?")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.renewlyTextSecondary)
                    
                    if !hasUnknownRenewalDate {
                        DatePicker(
                            "Renewal Date",
                            selection: $renewalDate,
                            displayedComponents: [.date]
                        )
                        .datePickerStyle(.graphical)
                        .tint(Color.renewlyPrimary)
                        .padding(10)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .stroke(Color.renewlyCardBorder, lineWidth: 1)
                        )
                    }
                    
                    Button(action: {
                        withAnimation {
                            hasUnknownRenewalDate.toggle()
                        }
                    }) {
                        HStack {
                            Image(systemName: hasUnknownRenewalDate ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(hasUnknownRenewalDate ? Color.renewlyPrimary : Color.renewlyTextMuted)
                            Text("I don't know the renewal date")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.renewlyTextPrimary)
                        }
                        .padding(12)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(hasUnknownRenewalDate ? Color.renewlyPrimaryUltraLight : Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .stroke(hasUnknownRenewalDate ? Color.renewlyPrimary : Color.renewlyCardBorder, lineWidth: 1)
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                
                // Save Button
                PrimaryButton(title: "Add Subscription", action: saveSubscription)
                    .padding(.top, 8)
                    .padding(.bottom, 24)
            }
            .padding(.horizontal, 20)
            .padding(.top, 12)
        }
    }
    
    // MARK: - Added Success Loop
    private func addedSuccessView(addedSub: SubscriptionModel) -> some View {
        VStack(spacing: 20) {
            Spacer()
            
            ConfettiCheckmarkView()
            
            VStack(spacing: 6) {
                Text("Nice! \(addedSub.name) is being tracked.")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.renewlyTextPrimary)
                    .multilineTextAlignment(.center)
                
                Text(addedSub.hasUnknownRenewalDate ? "Price: \(addedSub.currency)\(String(format: "%.2f", addedSub.price)) · Renewal date not set" : "Price: \(addedSub.currency)\(String(format: "%.2f", addedSub.price)) · Renews \(formattedDate(addedSub.nextRenewalDate))")
                    .font(.system(size: 14))
                    .foregroundColor(.renewlyTextSecondary)
            }
            .padding(.horizontal, 24)
            
            VStack(spacing: 12) {
                PrimaryButton(title: "+ Add Another Subscription", action: {
                    withAnimation {
                        justAddedSubscription = nil
                        selectedPreset = nil
                        searchText = ""
                    }
                })
                
                Button(action: {
                    dismiss()
                }) {
                    Text("Done")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.renewlyPrimary)
                        .padding(.vertical, 8)
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 16)
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 32)
    }
    
    // MARK: - Actions
    private func selectPreset(_ preset: ServicePreset) {
        selectedPreset = preset
        priceString = String(format: "%.2f", preset.defaultPrice)
        billingFrequency = .monthly
        renewalDate = Calendar.current.date(byAdding: .day, value: 30, to: Date()) ?? Date()
        hasUnknownRenewalDate = false
    }
    
    private func selectCustomPreset(name: String) {
        let preset = ServicePreset(
            id: UUID().uuidString,
            name: name,
            iconAssetName: nil,
            sfSymbolName: "creditcard.fill",
            brandColorHex: "6354EC",
            defaultPrice: 9.99,
            category: .other,
            defaultTrialDays: 0
        )
        selectPreset(preset)
    }
    
    private func saveSubscription() {
        guard let preset = selectedPreset else { return }
        let price = Double(priceString.replacingOccurrences(of: ",", with: ".")) ?? preset.defaultPrice
        
        let sub = SubscriptionModel(
            name: preset.name,
            iconAssetName: preset.iconAssetName,
            sfSymbolName: preset.sfSymbolName,
            brandColorHex: preset.brandColorHex,
            category: preset.category,
            type: .subscription,
            price: price,
            currency: UserPreferences.shared.currency.rawValue,
            billingFrequency: billingFrequency,
            startDate: Date(),
            nextRenewalDate: hasUnknownRenewalDate ? nil : renewalDate,
            hasUnknownRenewalDate: hasUnknownRenewalDate,
            status: .active,
            reminderDays: [1, 0],
            notes: ""
        )
        
        modelContext.insert(sub)
        NotificationManager.shared.scheduleReminders(for: sub)
        try? modelContext.save()
        
        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.impactOccurred()
        
        withAnimation {
            justAddedSubscription = sub
        }
    }
    
    private func formattedDate(_ date: Date?) -> String {
        guard let date = date else { return "Not set" }
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter.string(from: date)
    }
}
