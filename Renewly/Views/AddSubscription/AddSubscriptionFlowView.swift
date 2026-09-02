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
    @State private var selectedPlanName: String = ""
    @State private var customPlanName: String = ""
    @State private var isCustomPlan: Bool = false
    @State private var priceString: String = "17.99"
    @State private var currency: String = UserPreferences.shared.currency.rawValue
    @State private var billingFrequency: BillingFrequency = .monthly
    @State private var renewalDate: Date = Calendar.current.date(byAdding: .day, value: 3, to: Date()) ?? Date()
    @State private var hasUnknownRenewalDate: Bool = false
    @State private var selectedReminderOption: ReminderOption = .sevenDays
    @State private var customReminderDays: Int = 5
    
    private var serviceHasPlans: Bool {
        if let preset = selectedPreset {
            return preset.hasPredefinedPlans
        }
        return false
    }
    
    private var totalVisibleSteps: Int {
        serviceHasPlans ? 5 : 4
    }
    
    private var progressStepIndex: Int {
        if serviceHasPlans {
            return currentStep
        } else {
            // Map steps 1, 3, 4, 5 to 1, 2, 3, 4
            if currentStep == 1 { return 1 }
            if currentStep == 3 { return 2 }
            if currentStep == 4 { return 3 }
            if currentStep == 5 { return 4 }
            return 5
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Segmented Progress Bar
                if currentStep <= 5 {
                    SegmentedProgressBar(currentStep: progressStepIndex, totalSteps: totalVisibleSteps)
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
                                    if preset.hasPredefinedPlans {
                                        let defaultPlan = preset.plans.first
                                        selectedPlanName = defaultPlan?.name ?? ""
                                        priceString = String(format: "%.2f", defaultPlan?.defaultPrice ?? preset.defaultPrice)
                                        billingFrequency = defaultPlan?.billingFrequency ?? .monthly
                                        withAnimation(.easeInOut(duration: 0.25)) {
                                            currentStep = 2
                                        }
                                    } else {
                                        priceString = String(format: "%.2f", preset.defaultPrice)
                                        withAnimation(.easeInOut(duration: 0.25)) {
                                            currentStep = 3
                                        }
                                    }
                                } else {
                                    withAnimation(.easeInOut(duration: 0.25)) {
                                        currentStep = 3
                                    }
                                }
                            }
                        )
                        .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                        
                    case 2:
                        StepPlanSelection(
                            serviceName: name.isEmpty ? (selectedPreset?.name ?? "Service") : name,
                            availablePlans: selectedPreset?.plans ?? [],
                            selectedPlanName: $selectedPlanName,
                            customPlanName: $customPlanName,
                            isCustomPlan: $isCustomPlan,
                            onNext: {
                                if !isCustomPlan, let matchedPlan = selectedPreset?.plans.first(where: { $0.name == selectedPlanName }) {
                                    priceString = String(format: "%.2f", matchedPlan.defaultPrice)
                                    billingFrequency = matchedPlan.billingFrequency
                                }
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
                        Step2CostAndBilling(
                            priceString: $priceString,
                            currency: $currency,
                            billingFrequency: $billingFrequency,
                            onNext: {
                                withAnimation(.easeInOut(duration: 0.25)) {
                                    currentStep = 4
                                }
                            },
                            onBack: {
                                withAnimation(.easeInOut(duration: 0.25)) {
                                    currentStep = serviceHasPlans ? 2 : 1
                                }
                            }
                        )
                        .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                        
                    case 4:
                        Step3RenewalDate(
                            renewalDate: $renewalDate,
                            hasUnknownRenewalDate: $hasUnknownRenewalDate,
                            onNext: {
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
                        
                    case 5:
                        Step4Reminders(
                            selectedReminderOption: $selectedReminderOption,
                            customReminderDays: $customReminderDays,
                            onNext: {
                                saveSubscription()
                                withAnimation(.easeInOut(duration: 0.25)) {
                                    currentStep = 6
                                }
                            },
                            onBack: {
                                withAnimation(.easeInOut(duration: 0.25)) {
                                    currentStep = 4
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
                
                if currentStep <= 5 {
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
        
        let finalPlan: String?
        if isCustomPlan {
            let trimmed = customPlanName.trimmingCharacters(in: .whitespacesAndNewlines)
            finalPlan = trimmed.isEmpty ? nil : trimmed
        } else if !selectedPlanName.isEmpty {
            finalPlan = selectedPlanName
        } else {
            finalPlan = nil
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
            managementUrl: selectedPreset?.managementUrl,
            planName: finalPlan
        )
        
        modelContext.insert(newSub)
        try? modelContext.save()
        NotificationManager.shared.scheduleReminders(for: newSub)
    }
}
