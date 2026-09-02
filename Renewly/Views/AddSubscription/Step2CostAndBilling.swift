//
//  Step2CostAndBilling.swift
//  Renewly
//

import SwiftUI

struct Step2CostAndBilling: View {
    @Binding var priceString: String
    @Binding var currency: String
    @Binding var billingFrequency: BillingFrequency
    let onNext: () -> Void
    let onBack: () -> Void
    
    @FocusState private var isPriceFieldFocused: Bool
    @State private var customDaysString = "30"
    @State private var showCustomDaysSheet = false
    @State private var showValidationError = false
    
    private var isPriceValid: Bool {
        guard let price = Double(priceString.replacingOccurrences(of: ",", with: ".")), price > 0 else {
            return false
        }
        return true
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header
            VStack(alignment: .leading, spacing: 6) {
                Text("Step 2 of 5")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.renewlyTextMuted)
                
                Text("How much does\nit cost?")
                    .font(.system(size: 26, weight: .bold))
                    .foregroundColor(.renewlyTextPrimary)
                    .lineSpacing(2)
            }
            .padding(.horizontal, 24)
            .padding(.top, 16)
            .padding(.bottom, 24)
            
            // Price Input Box matching Screen 08
            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 10) {
                    Text(currency)
                        .font(.system(size: 26, weight: .bold, design: .rounded))
                        .foregroundColor(.renewlyTextSecondary)
                    
                    TextField("0.00", text: $priceString)
                        .font(.system(size: 26, weight: .bold, design: .rounded))
                        .foregroundColor(.renewlyTextPrimary)
                        .keyboardType(.decimalPad)
                        .focused($isPriceFieldFocused)
                        .onChange(of: priceString) { _, _ in
                            showValidationError = false
                        }
                    
                    if !priceString.isEmpty {
                        Button(action: { priceString = "" }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.renewlyTextMuted)
                                .font(.system(size: 16))
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(showValidationError ? Color.renewlyAttention : (isPriceFieldFocused ? Color.renewlyPrimary : Color.renewlyCardBorder), lineWidth: isPriceFieldFocused || showValidationError ? 1.5 : 1)
                )
                .shadow(color: Color.black.opacity(0.02), radius: 4, y: 1)
                
                if showValidationError {
                    Text("Please enter a valid price greater than zero.")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.renewlyAttention)
                        .padding(.horizontal, 4)
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 28)
            
            // Billing Section
            VStack(alignment: .leading, spacing: 14) {
                Text("Billing")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.renewlyTextSecondary)
                
                // Frequency Pills matching Screen 08
                HStack(spacing: 10) {
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
                
                // Custom pill
                let isCustom: Bool = {
                    if case .customDays = billingFrequency { return true }
                    return false
                }()
                
                BillingPill(
                    title: isCustom ? billingFrequency.rawString : "Custom",
                    isSelected: isCustom
                ) {
                    showCustomDaysSheet = true
                }
            }
            .padding(.horizontal, 24)
            
            Spacer()
            
            // Bottom Action & Back
            VStack(spacing: 12) {
                PrimaryButton(title: "Next", action: {
                    if isPriceValid {
                        isPriceFieldFocused = false
                        onNext()
                    } else {
                        showValidationError = true
                    }
                })
                
                Button(action: {
                    isPriceFieldFocused = false
                    onBack()
                }) {
                    Text("Back")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.renewlyPrimary)
                        .padding(.vertical, 6)
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 24)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            isPriceFieldFocused = false
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                isPriceFieldFocused = true
            }
        }
        .alert("Custom Billing Cycle", isPresented: $showCustomDaysSheet) {
            TextField("Number of days (e.g. 90)", text: $customDaysString)
                .keyboardType(.numberPad)
            Button("Cancel", role: .cancel) {}
            Button("Set") {
                if let days = Int(customDaysString), days > 0 {
                    billingFrequency = .customDays(days)
                }
            }
        } message: {
            Text("Enter the billing cycle duration in days.")
        }
    }
}

struct BillingPill: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: {
            let impact = UIImpactFeedbackGenerator(style: .light)
            impact.impactOccurred()
            action()
        }) {
            Text(title)
                .font(.system(size: 14, weight: isSelected ? .semibold : .medium))
                .foregroundColor(isSelected ? .white : .renewlyTextPrimary)
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(isSelected ? Color.renewlyPrimary : Color.white)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .stroke(isSelected ? Color.renewlyPrimary : Color.renewlyCardBorder, lineWidth: 1)
                )
                .shadow(color: isSelected ? Color.renewlyPrimary.opacity(0.12) : Color.black.opacity(0.02), radius: 3, y: 1)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
