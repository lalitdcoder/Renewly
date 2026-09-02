//
//  ChangePlanSheet.swift
//  Renewly
//

import SwiftUI
import SwiftData

struct ChangePlanSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @Bindable var subscription: SubscriptionModel
    
    @State private var selectedPlanName: String = ""
    @State private var customPlanText: String = ""
    @State private var isCustomSelected: Bool = false
    @State private var updatePriceToPlanDefault: Bool = true
    
    private var availablePlans: [ServicePlan] {
        ServicePreset.plans(for: subscription.name)
    }
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
                    // Header
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Which plan do you have?")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(.renewlyTextPrimary)
                        
                        Text("Select your current tier for \(subscription.name) to keep your records accurate.")
                            .font(.system(size: 14))
                            .foregroundColor(.renewlyTextSecondary)
                    }
                    .padding(.top, 12)
                    .padding(.horizontal, 20)
                    
                    if !availablePlans.isEmpty {
                        // Predefined Plan Cards
                        VStack(spacing: 10) {
                            ForEach(availablePlans) { plan in
                                let isSelected = !isCustomSelected && selectedPlanName == plan.name
                                
                                Button(action: {
                                    let impact = UIImpactFeedbackGenerator(style: .light)
                                    impact.impactOccurred()
                                    isCustomSelected = false
                                    selectedPlanName = plan.name
                                }) {
                                    HStack(alignment: .center, spacing: 14) {
                                        VStack(alignment: .leading, spacing: 3) {
                                            Text(plan.name)
                                                .font(.system(size: 15, weight: .bold))
                                                .foregroundColor(.renewlyTextPrimary)
                                            
                                            if let sub = plan.subtitle {
                                                Text(sub)
                                                    .font(.system(size: 12))
                                                    .foregroundColor(.renewlyTextSecondary)
                                                    .lineLimit(2)
                                            }
                                        }
                                        
                                        Spacer()
                                        
                                        VStack(alignment: .trailing, spacing: 2) {
                                            Text(String(format: "%@%.2f", subscription.currency, plan.defaultPrice))
                                                .font(.system(size: 14, weight: .bold, design: .rounded))
                                                .foregroundColor(.renewlyTextPrimary)
                                            
                                            Text(plan.billingFrequency.shortLabel)
                                                .font(.system(size: 11))
                                                .foregroundColor(.renewlyTextSecondary)
                                        }
                                        
                                        ZStack {
                                            Circle()
                                                .stroke(isSelected ? Color.renewlyPrimary : Color.renewlyCardBorder, lineWidth: 2)
                                                .frame(width: 22, height: 22)
                                            
                                            if isSelected {
                                                Circle()
                                                    .fill(Color.renewlyPrimary)
                                                    .frame(width: 12, height: 12)
                                            }
                                        }
                                        .padding(.leading, 4)
                                    }
                                    .padding(14)
                                    .background(isSelected ? Color.renewlyPrimaryUltraLight : Color.white)
                                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                                            .stroke(isSelected ? Color.renewlyPrimary : Color.renewlyCardBorder, lineWidth: isSelected ? 2 : 1)
                                    )
                                    .shadow(color: isSelected ? Color.renewlyPrimary.opacity(0.08) : Color.black.opacity(0.02), radius: 4, y: 1)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                            
                            // Custom Plan Option Card
                            Button(action: {
                                isCustomSelected = true
                            }) {
                                HStack(alignment: .center, spacing: 14) {
                                    VStack(alignment: .leading, spacing: 3) {
                                        Text("Custom plan / Other")
                                            .font(.system(size: 15, weight: .bold))
                                            .foregroundColor(.renewlyTextPrimary)
                                        Text("Enter a custom plan name (e.g. Student, Legacy)")
                                            .font(.system(size: 12))
                                            .foregroundColor(.renewlyTextSecondary)
                                    }
                                    
                                    Spacer()
                                    
                                    ZStack {
                                        Circle()
                                            .stroke(isCustomSelected ? Color.renewlyPrimary : Color.renewlyCardBorder, lineWidth: 2)
                                            .frame(width: 22, height: 22)
                                        
                                        if isCustomSelected {
                                            Circle()
                                                .fill(Color.renewlyPrimary)
                                                .frame(width: 12, height: 12)
                                        }
                                    }
                                }
                                .padding(14)
                                .background(isCustomSelected ? Color.renewlyPrimaryUltraLight : Color.white)
                                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                                        .stroke(isCustomSelected ? Color.renewlyPrimary : Color.renewlyCardBorder, lineWidth: isCustomSelected ? 2 : 1)
                                    )
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        .padding(.horizontal, 20)
                    }
                    
                    // Custom text input if custom selected or no predefined plans
                    if isCustomSelected || availablePlans.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Plan Name")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.renewlyTextSecondary)
                            
                            TextField("e.g. Family, Pro, 200 GB, Student", text: $customPlanText)
                                .font(.system(size: 15))
                                .padding(14)
                                .background(Color.white)
                                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                                        .stroke(Color.renewlyCardBorder, lineWidth: 1)
                                )
                        }
                        .padding(.horizontal, 20)
                    }
                    
                    // Update price toggle if a known plan is selected and price differs
                    if let matchedPlan = availablePlans.first(where: { $0.name == selectedPlanName }),
                       !isCustomSelected,
                       abs(matchedPlan.defaultPrice - subscription.price) > 0.01 {
                        Toggle(isOn: $updatePriceToPlanDefault) {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Update price to \(String(format: "%@%.2f", subscription.currency, matchedPlan.defaultPrice))")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.renewlyTextPrimary)
                                Text("Matches the standard \(matchedPlan.name) pricing")
                                    .font(.system(size: 12))
                                    .foregroundColor(.renewlyTextSecondary)
                            }
                        }
                        .tint(Color.renewlyPrimary)
                        .padding(14)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .stroke(Color.renewlyCardBorder, lineWidth: 1)
                        )
                        .padding(.horizontal, 20)
                    }
                    
                    // Action button
                    PrimaryButton(title: "Save Plan") {
                        savePlanSelection()
                        dismiss()
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 8)
                    .padding(.bottom, 32)
                }
            }
            .background(Color.renewlyBackground.ignoresSafeArea())
            .navigationTitle("Select Plan")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.renewlyTextSecondary)
                }
            }
            .onAppear {
                loadInitialState()
            }
        }
    }
    
    private func loadInitialState() {
        if let currentPlan = subscription.planName, !currentPlan.isEmpty {
            if availablePlans.contains(where: { $0.name == currentPlan }) {
                selectedPlanName = currentPlan
                isCustomSelected = false
            } else {
                isCustomSelected = true
                customPlanText = currentPlan
            }
        } else if let firstPlan = availablePlans.first {
            selectedPlanName = firstPlan.name
            isCustomSelected = false
        } else {
            isCustomSelected = true
        }
    }
    
    private func savePlanSelection() {
        let finalPlan: String?
        if isCustomSelected || availablePlans.isEmpty {
            let trimmed = customPlanText.trimmingCharacters(in: .whitespacesAndNewlines)
            finalPlan = trimmed.isEmpty ? nil : trimmed
        } else {
            finalPlan = selectedPlanName.isEmpty ? nil : selectedPlanName
        }
        
        subscription.planName = finalPlan
        
        // If user chose to sync default price
        if !isCustomSelected,
           let matchedPlan = availablePlans.first(where: { $0.name == selectedPlanName }),
           updatePriceToPlanDefault {
            if subscription.type == .subscription {
                subscription.price = matchedPlan.defaultPrice
                subscription.billingFrequency = matchedPlan.billingFrequency
            } else if subscription.type == .trial {
                subscription.priceAfterTrial = matchedPlan.defaultPrice
            }
        }
        
        subscription.updatedAt = Date()
        try? modelContext.save()
        NotificationManager.shared.scheduleReminders(for: subscription)
    }
}
