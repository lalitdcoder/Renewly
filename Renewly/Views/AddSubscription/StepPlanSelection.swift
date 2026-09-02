//
//  StepPlanSelection.swift
//  Renewly
//

import SwiftUI

struct StepPlanSelection: View {
    let serviceName: String
    let availablePlans: [ServicePlan]
    @Binding var selectedPlanName: String
    @Binding var customPlanName: String
    @Binding var isCustomPlan: Bool
    let onNext: () -> Void
    let onBack: () -> Void
    
    var isNextEnabled: Bool {
        if isCustomPlan {
            return !customPlanName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        }
        return !selectedPlanName.isEmpty || !availablePlans.isEmpty
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header
            VStack(alignment: .leading, spacing: 6) {
                Text("Step 2 of 5")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.renewlyTextMuted)
                
                Text("Which plan do\nyou have?")
                    .font(.system(size: 26, weight: .bold))
                    .foregroundColor(.renewlyTextPrimary)
                    .lineSpacing(2)
            }
            .padding(.horizontal, 24)
            .padding(.top, 16)
            .padding(.bottom, 20)
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 12) {
                    ForEach(availablePlans) { plan in
                        let isSelected = !isCustomPlan && (selectedPlanName == plan.name || (selectedPlanName.isEmpty && availablePlans.first?.id == plan.id))
                        
                        Button(action: {
                            let impact = UIImpactFeedbackGenerator(style: .light)
                            impact.impactOccurred()
                            isCustomPlan = false
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
                                    Text(String(format: "%@%.2f", UserPreferences.shared.currency.rawValue, plan.defaultPrice))
                                        .font(.system(size: 15, weight: .bold, design: .rounded))
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
                            .padding(16)
                            .background(isSelected ? Color.renewlyPrimaryUltraLight : Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                            .overlay(
                                RoundedRectangle(cornerRadius: 18, style: .continuous)
                                    .stroke(isSelected ? Color.renewlyPrimary : Color.renewlyCardBorder, lineWidth: isSelected ? 2 : 1)
                            )
                            .shadow(color: isSelected ? Color.renewlyPrimary.opacity(0.08) : Color.black.opacity(0.02), radius: 4, y: 1)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    
                    // Custom / Other plan option
                    Button(action: {
                        let impact = UIImpactFeedbackGenerator(style: .light)
                        impact.impactOccurred()
                        isCustomPlan = true
                    }) {
                        HStack(alignment: .center, spacing: 14) {
                            VStack(alignment: .leading, spacing: 3) {
                                Text("Custom plan / Other")
                                    .font(.system(size: 15, weight: .bold))
                                    .foregroundColor(.renewlyTextPrimary)
                                Text("Enter a custom plan name")
                                    .font(.system(size: 12))
                                    .foregroundColor(.renewlyTextSecondary)
                            }
                            
                            Spacer()
                            
                            ZStack {
                                Circle()
                                    .stroke(isCustomPlan ? Color.renewlyPrimary : Color.renewlyCardBorder, lineWidth: 2)
                                    .frame(width: 22, height: 22)
                                
                                if isCustomPlan {
                                    Circle()
                                        .fill(Color.renewlyPrimary)
                                        .frame(width: 12, height: 12)
                                }
                            }
                        }
                        .padding(16)
                        .background(isCustomPlan ? Color.renewlyPrimaryUltraLight : Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 18, style: .continuous)
                                .stroke(isCustomPlan ? Color.renewlyPrimary : Color.renewlyCardBorder, lineWidth: isCustomPlan ? 2 : 1)
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    if isCustomPlan {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Plan Name")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(.renewlyTextSecondary)
                            
                            TextField("e.g. Student, Legacy, Family", text: $customPlanName)
                                .font(.system(size: 15))
                                .padding(14)
                                .background(Color.white)
                                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                                        .stroke(Color.renewlyCardBorder, lineWidth: 1)
                                )
                        }
                        .padding(.top, 4)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
            }
            
            Spacer(minLength: 8)
            
            // Actions
            VStack(spacing: 12) {
                PrimaryButton(title: "Next", isEnabled: isNextEnabled, action: onNext)
                
                Button("Back", action: onBack)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.renewlyPrimary)
                    .padding(.vertical, 6)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 24)
        }
    }
}
