//
//  AddSubscriptionFlowView.swift
//  Renewly
//

import SwiftUI
import SwiftData

struct AddSubscriptionFlowView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @State private var currentStep = 1
    
    // Form fields
    @State private var selectedPreset: ServicePreset? = ServicePreset.popularSubscriptions.first
    @State private var name: String = "Netflix"
    @State private var category: SubscriptionCategory = .entertainment
    @State private var priceString: String = "17.99"
    @State private var currency: String = UserPreferences.shared.currency.rawValue
    @State private var billingFrequency: BillingFrequency = .monthly
    @State private var renewalDate: Date = Calendar.current.date(byAdding: .day, value: 3, to: Date()) ?? Date()
    @State private var hasUnknownRenewalDate: Bool = false
    @State private var selectedReminderOption: ReminderOption = .sevenDays
    @State private var customReminderDays: Int = 5
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Segmented Progress Bar (Steps 1 to 4)
                if currentStep <= 4 {
                    SegmentedProgressBar(currentStep: currentStep, totalSteps: 5)
                        .padding(.top, 12)
                        .padding(.bottom, 8)
                }
                
                // Step Content
                ZStack {
                    switch currentStep {
                    case 1:
                        Step1ServiceSelection(
                            selectedPreset: $selectedPreset,
                            customName: $name,
                            selectedCategory: $category,
                            onNext: {
                                if let preset = selectedPreset {
                                    priceString = String(format: "%.2f", preset.defaultPrice)
                                }
                                withAnimation(.easeInOut(duration: 0.25)) {
                                    currentStep = 2
                                }
                            }
                        )
                        .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                        
                    case 2:
                        Step2CostAndBilling(
                            priceString: $priceString,
                            currency: $currency,
                            billingFrequency: $billingFrequency,
                            onNext: {
                                withAnimation(.easeInOut(duration: 0.25)) {
                                    currentStep = 3
                                }
                            },
                            onBack: {
                                withAnimation(.easeInOut(duration: 0.25)) {
                                    currentStep = 1
                                }
                            }
                        )
                        .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                        
                    case 3:
                        Step3RenewalDate(
                            renewalDate: $renewalDate,
                            hasUnknownRenewalDate: $hasUnknownRenewalDate,
                            onNext: {
                                withAnimation(.easeInOut(duration: 0.25)) {
                                    currentStep = 4
                                }
                            },
                            onBack: {
                                withAnimation(.easeInOut(duration: 0.25)) {
                                    currentStep = 2
                                }
                            }
                        )
                        .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                        
                    case 4:
                        Step4Reminders(
                            selectedReminderOption: $selectedReminderOption,
                            customReminderDays: $customReminderDays,
                            onNext: {
                                saveSubscription()
                                withAnimation(.easeInOut(duration: 0.25)) {
                                    currentStep = 5
                                }
                            },
                            onBack: {
                                withAnimation(.easeInOut(duration: 0.25)) {
                                    currentStep = 3
                                }
                            }
                        )
                        .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                        
                    default:
                        Step5Confirmation(
                            name: name.isEmpty ? (selectedPreset?.name ?? "Subscription") : name,
                            iconAssetName: selectedPreset?.iconAssetName,
                            sfSymbolName: selectedPreset?.sfSymbolName ?? "creditcard.fill",
                            brandColorHex: selectedPreset?.brandColorHex ?? "6354EC",
                            price: Double(priceString.replacingOccurrences(of: ",", with: ".")) ?? 0.0,
                            currency: currency,
                            billingFrequency: billingFrequency,
                            renewalDate: renewalDate,
                            hasUnknownRenewalDate: hasUnknownRenewalDate,
                            onDone: {
                                dismiss()
                            }
                        )
                        .transition(.scale.combined(with: .opacity))
                    }
                }
            }
            .background(Color.renewlyBackground.ignoresSafeArea())
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Add Subscription")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.renewlyTextPrimary)
                }
                
                if currentStep <= 4 {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Cancel") {
                            dismiss()
                        }
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(.renewlyPrimary)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private func saveSubscription() {
        let price = Double(priceString.replacingOccurrences(of: ",", with: ".")) ?? 0.0
        let effectiveName = name.trimmingCharacters(in: .whitespaces).isEmpty ? (selectedPreset?.name ?? "Subscription") : name
        
        var reminderDays: [Int] = [7]
        switch selectedReminderOption {
        case .sevenDays: reminderDays = [7]
        case .threeDays: reminderDays = [3]
        case .oneDay: reminderDays = [1]
        case .custom: reminderDays = [customReminderDays]
        }
        
        let newSub = SubscriptionModel(
            name: effectiveName,
            iconAssetName: selectedPreset?.iconAssetName,
            sfSymbolName: selectedPreset?.sfSymbolName ?? "creditcard.fill",
            brandColorHex: selectedPreset?.brandColorHex ?? "6354EC",
            category: category,
            type: .subscription,
            price: price,
            currency: currency,
            billingFrequency: billingFrequency,
            startDate: Date(),
            nextRenewalDate: hasUnknownRenewalDate ? nil : renewalDate,
            hasUnknownRenewalDate: hasUnknownRenewalDate,
            status: .active,
            reminderDays: reminderDays,
            managementUrl: selectedPreset?.managementUrl
        )
        
        modelContext.insert(newSub)
        try? modelContext.save()
        NotificationManager.shared.scheduleReminders(for: newSub)
    }
}
