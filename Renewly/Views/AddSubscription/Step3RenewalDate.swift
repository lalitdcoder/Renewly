//
//  Step3RenewalDate.swift
//  Renewly
//

import SwiftUI

struct Step3RenewalDate: View {
    @Binding var renewalDate: Date
    @Binding var hasUnknownRenewalDate: Bool
    let onNext: () -> Void
    let onBack: () -> Void
    
    @State private var showDatePicker = false
    
    private var formattedDateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyyy"
        return formatter.string(from: renewalDate)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header
            VStack(alignment: .leading, spacing: 6) {
                Text("Step 3 of 5")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.renewlyTextMuted)
                
                Text("When does\nit renew?")
                    .font(.system(size: 26, weight: .bold))
                    .foregroundColor(.renewlyTextPrimary)
                    .lineSpacing(2)
            }
            .padding(.horizontal, 24)
            .padding(.top, 16)
            .padding(.bottom, 24)
            
            // Date Selection Box matching Screen 09
            Button(action: {
                hasUnknownRenewalDate = false
                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                    showDatePicker.toggle()
                }
            }) {
                HStack {
                    Text(hasUnknownRenewalDate ? "Select renewal date" : formattedDateString)
                        .font(.system(size: 16, weight: hasUnknownRenewalDate ? .regular : .semibold))
                        .foregroundColor(hasUnknownRenewalDate ? .renewlyTextMuted : .renewlyTextPrimary)
                    
                    Spacer()
                    
                    Image(systemName: "calendar")
                        .font(.system(size: 18))
                        .foregroundColor(!hasUnknownRenewalDate ? Color.renewlyPrimary : Color.renewlyTextMuted)
                }
                .padding(.horizontal, 18)
                .padding(.vertical, 16)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(!hasUnknownRenewalDate ? Color.renewlyPrimary : Color.renewlyCardBorder, lineWidth: !hasUnknownRenewalDate ? 1.5 : 1)
                )
                .shadow(color: !hasUnknownRenewalDate ? Color.renewlyPrimary.opacity(0.06) : Color.black.opacity(0.02), radius: 4, y: 1)
            }
            .buttonStyle(PlainButtonStyle())
            .padding(.horizontal, 24)
            .padding(.bottom, 12)
            
            // Inline Graphical DatePicker
            if showDatePicker && !hasUnknownRenewalDate {
                DatePicker(
                    "Renewal Date",
                    selection: $renewalDate,
                    displayedComponents: [.date]
                )
                .datePickerStyle(.graphical)
                .tint(Color.renewlyPrimary)
                .padding(12)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .stroke(Color.renewlyCardBorder, lineWidth: 1)
                )
                .padding(.horizontal, 24)
                .padding(.bottom, 12)
            }
            
            // "I don't know" button matching Screen 09
            Button(action: {
                let impact = UIImpactFeedbackGenerator(style: .light)
                impact.impactOccurred()
                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                    hasUnknownRenewalDate = true
                    showDatePicker = false
                }
            }) {
                VStack(spacing: 4) {
                    Text("I don't know")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(hasUnknownRenewalDate ? Color.renewlyPrimary : Color.renewlyTextPrimary)
                    
                    if hasUnknownRenewalDate {
                        Text("We'll track your subscription and remind you once you add a date.")
                            .font(.system(size: 12))
                            .foregroundColor(.renewlyTextSecondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 8)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .padding(.horizontal, 12)
                .background(hasUnknownRenewalDate ? Color.renewlyPrimaryUltraLight : Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(hasUnknownRenewalDate ? Color.renewlyPrimary : Color.renewlyCardBorder, lineWidth: hasUnknownRenewalDate ? 1.5 : 1)
                )
                .shadow(color: hasUnknownRenewalDate ? Color.renewlyPrimary.opacity(0.08) : Color.black.opacity(0.02), radius: 4, y: 1)
            }
            .buttonStyle(PlainButtonStyle())
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
    }
}
