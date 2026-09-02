//
//  Step4Reminders.swift
//  Renewly
//

import SwiftUI

struct Step4Reminders: View {
    @Binding var selectedReminderOption: ReminderOption
    @Binding var customReminderDays: Int
    let onNext: () -> Void
    let onBack: () -> Void
    
    @State private var customDaysText = "5"
    @State private var showCustomDaysPrompt = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header
            VStack(alignment: .leading, spacing: 6) {
                Text("Step 4 of 5")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.renewlyTextMuted)
                
                Text("When should we\nremind you?")
                    .font(.system(size: 26, weight: .bold))
                    .foregroundColor(.renewlyTextPrimary)
                    .lineSpacing(2)
            }
            .padding(.horizontal, 24)
            .padding(.top, 16)
            .padding(.bottom, 24)
            
            // Radio list matching Screen 10
            VStack(spacing: 12) {
                RadioOptionRow(
                    title: "7 days before",
                    isSelected: selectedReminderOption == .sevenDays
                ) {
                    selectedReminderOption = .sevenDays
                }
                
                RadioOptionRow(
                    title: "3 days before",
                    isSelected: selectedReminderOption == .threeDays
                ) {
                    selectedReminderOption = .threeDays
                }
                
                RadioOptionRow(
                    title: "1 day before",
                    isSelected: selectedReminderOption == .oneDay
                ) {
                    selectedReminderOption = .oneDay
                }
                
                RadioOptionRow(
                    title: selectedReminderOption == .custom ? "\(customReminderDays) days before" : "Custom",
                    isSelected: selectedReminderOption == .custom
                ) {
                    selectedReminderOption = .custom
                    showCustomDaysPrompt = true
                }
            }
            .padding(.horizontal, 24)
            
            Spacer()
            
            // Bottom Action & Back
            VStack(spacing: 12) {
                PrimaryButton(title: "Next", action: onNext)
                
                Button(action: onBack) {
                    Text("Back")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.renewlyPrimary)
                        .padding(.vertical, 6)
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 24)
        }
        .alert("Custom Reminder", isPresented: $showCustomDaysPrompt) {
            TextField("Days before renewal", text: $customDaysText)
                .keyboardType(.numberPad)
            Button("Cancel", role: .cancel) {}
            Button("Save") {
                if let days = Int(customDaysText), days > 0 {
                    customReminderDays = days
                    selectedReminderOption = .custom
                }
            }
        } message: {
            Text("How many days before renewal would you like to be notified?")
        }
    }
}

enum ReminderOption: Equatable {
    case sevenDays
    case threeDays
    case oneDay
    case custom
    
    var daysArray: [Int] {
        switch self {
        case .sevenDays: return [7]
        case .threeDays: return [3]
        case .oneDay: return [1]
        case .custom: return [5]
        }
    }
}
