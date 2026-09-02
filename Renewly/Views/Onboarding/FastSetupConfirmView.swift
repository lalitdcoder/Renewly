//
//  FastSetupConfirmView.swift
//  Renewly
//

import SwiftUI

struct FastSetupConfirmView: View {
    @Binding var selectedItems: [FastSetupItem]
    let onQuickSetupComplete: () -> Void
    let onBack: () -> Void
    
    @State private var editingItemIndex: Int? = nil
    
    private var totalMonthlyEstimate: Double {
        selectedItems.reduce(0.0) { sum, item in
            if item.isTrial { return sum }
            switch item.billingFrequency {
            case .monthly: return sum + item.price
            case .yearly: return sum + (item.price / 12.0)
            case .weekly: return sum + (item.price * 52.0 / 12.0)
            case .customDays(let days): return sum + (days > 0 ? item.price * 30.0 / Double(days) : item.price)
            }
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            VStack(alignment: .leading, spacing: 6) {
                Text("Your Subscriptions")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.renewlyTextPrimary)
                
                Text("We've pre-filled standard prices and dates. Tap any item to customize, or tap Quick Setup to start tracking immediately.")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.renewlyTextSecondary)
                    .lineSpacing(2)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 24)
            .padding(.top, 16)
            .padding(.bottom, 16)
            
            // Subscriptions List
            ScrollView(showsIndicators: false) {
                VStack(spacing: 10) {
                    ForEach(Array(selectedItems.enumerated()), id: \.element.id) { index, item in
                        Button(action: {
                            editingItemIndex = index
                        }) {
                            HStack(spacing: 12) {
                                ServiceIconView(
                                    name: item.name,
                                    iconAssetName: item.iconAssetName,
                                    sfSymbolName: item.sfSymbolName,
                                    brandColorHex: item.brandColorHex,
                                    size: 44,
                                    cornerRadius: 12
                                )
                                
                                VStack(alignment: .leading, spacing: 3) {
                                    HStack(spacing: 6) {
                                        Text(item.name)
                                            .font(.system(size: 15, weight: .bold))
                                            .foregroundColor(.renewlyTextPrimary)
                                        
                                        if item.isTrial {
                                            TrialBadgeView(text: "FREE TRIAL", isUrgent: false)
                                        }
                                    }
                                    
                                    HStack(spacing: 4) {
                                        Text(item.hasUnknownRenewalDate ? "Renewal: Not set" : "Renews \(formattedShortDate(item.renewalDate))")
                                            .font(.system(size: 12))
                                            .foregroundColor(.renewlyTextSecondary)
                                    }
                                }
                                
                                Spacer()
                                
                                VStack(alignment: .trailing, spacing: 2) {
                                    Text(item.isTrial ? "Free" : String(format: "%@%.2f", item.currency, item.price))
                                        .font(.system(size: 15, weight: .bold, design: .rounded))
                                        .foregroundColor(.renewlyTextPrimary)
                                    
                                    Text(item.billingFrequency.rawString)
                                        .font(.system(size: 11))
                                        .foregroundColor(.renewlyTextMuted)
                                }
                                
                                Image(systemName: "pencil.circle.fill")
                                    .font(.system(size: 16))
                                    .foregroundColor(.renewlyPrimary.opacity(0.8))
                                    .padding(.leading, 4)
                            }
                            .padding(14)
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                            .overlay(
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .stroke(Color.renewlyCardBorder, lineWidth: 1)
                            )
                            .shadow(color: Color.black.opacity(0.02), radius: 3, y: 1)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
            }
            
            // Bottom Action Area
            VStack(spacing: 10) {
                PrimaryButton(
                    title: "Quick Setup (\(selectedItems.count) Subscriptions)",
                    action: onQuickSetupComplete
                )
                
                Button(action: onBack) {
                    Text("Back to Selection")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.renewlyTextSecondary)
                        .padding(.vertical, 4)
                }
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
            .background(
                Color.white
                    .shadow(color: Color.black.opacity(0.04), radius: 8, y: -2)
                    .ignoresSafeArea(edges: .bottom)
            )
        }
        .background(Color.renewlyBackground.ignoresSafeArea())
        .sheet(item: Binding(
            get: { editingItemIndex.map { EditWrapper(index: $0, item: selectedItems[$0]) } },
            set: { editingItemIndex = $0?.index }
        )) { wrapper in
            FastSetupQuickEditSheet(item: $selectedItems[wrapper.index])
        }
    }
    
    private func formattedShortDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter.string(from: date)
    }
}

private struct EditWrapper: Identifiable {
    let index: Int
    let item: FastSetupItem
    var id: String { item.id }
}

// MARK: - Fast Inline Editor Sheet
struct FastSetupQuickEditSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var item: FastSetupItem
    
    @State private var priceString: String = ""
    @State private var renewalDate: Date = Date()
    @State private var hasUnknownRenewalDate: Bool = false
    @State private var frequency: BillingFrequency = .monthly
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Header
                    HStack(spacing: 12) {
                        ServiceIconView(
                            name: item.name,
                            iconAssetName: item.iconAssetName,
                            sfSymbolName: item.sfSymbolName,
                            brandColorHex: item.brandColorHex,
                            size: 48,
                            cornerRadius: 14
                        )
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text(item.name)
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.renewlyTextPrimary)
                            Text(item.category.rawValue)
                                .font(.system(size: 13))
                                .foregroundColor(.renewlyTextSecondary)
                        }
                    }
                    .padding(.top, 8)
                    
                    // Price Box
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Price")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.renewlyTextSecondary)
                        
                        HStack(spacing: 8) {
                            Text(item.currency)
                                .font(.system(size: 22, weight: .bold, design: .rounded))
                                .foregroundColor(.renewlyTextSecondary)
                            
                            TextField("0.00", text: $priceString)
                                .font(.system(size: 22, weight: .bold, design: .rounded))
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
                    
                    // Frequency Box
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Billing Cycle")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.renewlyTextSecondary)
                        
                        HStack(spacing: 8) {
                            BillingPill(title: "Monthly", isSelected: frequency == .monthly) {
                                frequency = .monthly
                            }
                            BillingPill(title: "Yearly", isSelected: frequency == .yearly) {
                                frequency = .yearly
                            }
                            BillingPill(title: "Weekly", isSelected: frequency == .weekly) {
                                frequency = .weekly
                            }
                        }
                    }
                    
                    // Renewal Date Box
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Next Renewal Date")
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
                }
                .padding(20)
            }
            .background(Color.renewlyBackground.ignoresSafeArea())
            .navigationTitle("Edit Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        if let newPrice = Double(priceString.replacingOccurrences(of: ",", with: ".")) {
                            item.price = newPrice
                        }
                        item.billingFrequency = frequency
                        item.renewalDate = renewalDate
                        item.hasUnknownRenewalDate = hasUnknownRenewalDate
                        dismiss()
                    }
                    .fontWeight(.bold)
                    .foregroundColor(.renewlyPrimary)
                }
            }
            .onAppear {
                priceString = String(format: "%.2f", item.price)
                renewalDate = item.renewalDate
                hasUnknownRenewalDate = item.hasUnknownRenewalDate
                frequency = item.billingFrequency
            }
        }
    }
}
