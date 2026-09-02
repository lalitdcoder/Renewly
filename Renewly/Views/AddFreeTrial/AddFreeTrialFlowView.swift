//
//  AddFreeTrialFlowView.swift
//  Renewly
//

import SwiftUI
import SwiftData

struct AddFreeTrialFlowView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @State private var currentStep = 1
    
    // Trial Form Fields
    @State private var selectedPreset: ServicePreset? = ServicePreset.popularTrials.first
    @State private var name: String = "Canva"
    @State private var category: SubscriptionCategory = .productivity
    @State private var startDate: Date = Date()
    @State private var trialDurationDays: Int = 14
    @State private var customDurationText: String = "14"
    @State private var priceAfterTrialString: String = "12.99"
    @State private var currency: String = UserPreferences.shared.currency.rawValue
    @State private var reminderDays: [Int] = [7, 1]
    
    private var calculatedEndDate: Date {
        Calendar.current.date(byAdding: .day, value: trialDurationDays, to: startDate) ?? Date()
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Segmented Progress (Steps 1 to 4)
                if currentStep <= 4 {
                    SegmentedProgressBar(currentStep: currentStep, totalSteps: 4)
                        .padding(.top, 12)
                        .padding(.bottom, 8)
                }
                
                ZStack {
                    switch currentStep {
                    case 1:
                        trialStep1Service
                            .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                    case 2:
                        trialStep2StartDate
                            .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                    case 3:
                        trialStep3Duration
                            .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                    case 4:
                        trialStep4CostAfterwards
                            .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                    default:
                        trialConfirmation
                            .transition(.scale.combined(with: .opacity))
                    }
                }
            }
            .background(Color.renewlyBackground.ignoresSafeArea())
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Add Free Trial")
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
    
    // MARK: - Step 1: Service Selection (Screen 12)
    @State private var searchText = ""
    private var filteredTrialPresets: [ServicePreset] {
        if searchText.trimmingCharacters(in: .whitespaces).isEmpty {
            return ServicePreset.popularTrials
        }
        return ServicePreset.allPresets.filter {
            $0.name.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    private var trialStep1Service: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 6) {
                Text("Step 1 of 4")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.renewlyTextMuted)
                
                Text("What trial are you\nstarting?")
                    .font(.system(size: 26, weight: .bold))
                    .foregroundColor(.renewlyTextPrimary)
                    .lineSpacing(2)
            }
            .padding(.horizontal, 24)
            .padding(.top, 16)
            .padding(.bottom, 20)
            
            // Search field
            HStack(spacing: 10) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.renewlyTextMuted)
                TextField("Search for a service", text: $searchText)
                    .font(.system(size: 15))
                    .onChange(of: searchText) { _, newValue in
                        if !newValue.isEmpty { name = newValue }
                    }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 11)
            .background(Color(hex: "F2F2F6"))
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            .padding(.horizontal, 24)
            .padding(.bottom, 20)
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Popular")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.renewlyTextSecondary)
                        .padding(.horizontal, 24)
                    
                    LazyVGrid(
                        columns: [
                            GridItem(.flexible(), spacing: 12),
                            GridItem(.flexible(), spacing: 12),
                            GridItem(.flexible(), spacing: 12)
                        ],
                        spacing: 12
                    ) {
                        ForEach(filteredTrialPresets) { preset in
                            let isSelected = selectedPreset?.id == preset.id
                            
                            Button(action: {
                                let impact = UIImpactFeedbackGenerator(style: .light)
                                impact.impactOccurred()
                                selectedPreset = preset
                                name = preset.name
                                category = preset.category
                                trialDurationDays = preset.defaultTrialDays > 0 ? preset.defaultTrialDays : 14
                                priceAfterTrialString = String(format: "%.2f", preset.defaultPrice)
                            }) {
                                VStack(spacing: 10) {
                                    ServiceIconView(
                                        name: preset.name,
                                        iconAssetName: preset.iconAssetName,
                                        sfSymbolName: preset.sfSymbolName,
                                        brandColorHex: preset.brandColorHex,
                                        size: 44
                                    )
                                    
                                    Text(preset.name)
                                        .font(.system(size: 12, weight: .medium))
                                        .foregroundColor(.renewlyTextPrimary)
                                        .lineLimit(1)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .padding(.horizontal, 6)
                                .background(Color.white)
                                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                                        .stroke(isSelected ? Color.renewlyPrimary : Color.renewlyCardBorder, lineWidth: isSelected ? 2 : 1)
                                )
                                .shadow(color: isSelected ? Color.renewlyPrimary.opacity(0.12) : Color.black.opacity(0.02), radius: 4, y: 1)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.horizontal, 24)
                }
            }
            
            Spacer()
            
            PrimaryButton(title: "Next") {
                withAnimation(.easeInOut(duration: 0.25)) {
                    currentStep = 2
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 24)
        }
    }
    
    // MARK: - Step 2: Start Date
    private var trialStep2StartDate: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 6) {
                Text("Step 2 of 4")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.renewlyTextMuted)
                
                Text("When did it start?")
                    .font(.system(size: 26, weight: .bold))
                    .foregroundColor(.renewlyTextPrimary)
            }
            .padding(.horizontal, 24)
            .padding(.top, 16)
            .padding(.bottom, 24)
            
            DatePicker("Start Date", selection: $startDate, displayedComponents: [.date])
                .datePickerStyle(.graphical)
                .tint(Color.renewlyPrimary)
                .padding(14)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .stroke(Color.renewlyCardBorder, lineWidth: 1)
                )
                .padding(.horizontal, 24)
            
            Spacer()
            
            VStack(spacing: 12) {
                PrimaryButton(title: "Next") {
                    withAnimation(.easeInOut(duration: 0.25)) {
                        currentStep = 3
                    }
                }
                
                Button("Back") {
                    withAnimation(.easeInOut(duration: 0.25)) {
                        currentStep = 1
                    }
                }
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(.renewlyPrimary)
                .padding(.vertical, 6)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 24)
        }
    }
    
    // MARK: - Step 3: Trial Duration
    @State private var showCustomDurationAlert = false
    private var trialStep3Duration: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 6) {
                Text("Step 3 of 4")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.renewlyTextMuted)
                
                Text("How long is\nthe trial?")
                    .font(.system(size: 26, weight: .bold))
                    .foregroundColor(.renewlyTextPrimary)
                    .lineSpacing(2)
            }
            .padding(.horizontal, 24)
            .padding(.top, 16)
            .padding(.bottom, 24)
            
            VStack(spacing: 12) {
                RadioOptionRow(title: "7 days", isSelected: trialDurationDays == 7) {
                    trialDurationDays = 7
                }
                
                RadioOptionRow(title: "14 days", isSelected: trialDurationDays == 14) {
                    trialDurationDays = 14
                }
                
                RadioOptionRow(title: "30 days", isSelected: trialDurationDays == 30) {
                    trialDurationDays = 30
                }
                
                let isCustom = trialDurationDays != 7 && trialDurationDays != 14 && trialDurationDays != 30
                RadioOptionRow(
                    title: isCustom ? "\(trialDurationDays) days" : "Custom",
                    isSelected: isCustom
                ) {
                    showCustomDurationAlert = true
                }
            }
            .padding(.horizontal, 24)
            
            Spacer()
            
            VStack(spacing: 12) {
                PrimaryButton(title: "Next") {
                    withAnimation(.easeInOut(duration: 0.25)) {
                        currentStep = 4
                    }
                }
                
                Button("Back") {
                    withAnimation(.easeInOut(duration: 0.25)) {
                        currentStep = 2
                    }
                }
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(.renewlyPrimary)
                .padding(.vertical, 6)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 24)
        }
        .alert("Custom Trial Length", isPresented: $showCustomDurationAlert) {
            TextField("Days (e.g. 60)", text: $customDurationText)
                .keyboardType(.numberPad)
            Button("Cancel", role: .cancel) {}
            Button("Save") {
                if let days = Int(customDurationText), days > 0 {
                    trialDurationDays = days
                }
            }
        }
    }
    
    // MARK: - Step 4: Cost Afterwards & Reminders
    private var trialStep4CostAfterwards: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 6) {
                Text("Step 4 of 4")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.renewlyTextMuted)
                
                Text("What will it cost\nafterwards?")
                    .font(.system(size: 26, weight: .bold))
                    .foregroundColor(.renewlyTextPrimary)
                    .lineSpacing(2)
            }
            .padding(.horizontal, 24)
            .padding(.top, 16)
            .padding(.bottom, 24)
            
            // Price Input
            HStack(spacing: 8) {
                Text(currency)
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(.renewlyTextSecondary)
                
                TextField("0.00", text: $priceAfterTrialString)
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundColor(.renewlyTextPrimary)
                    .keyboardType(.decimalPad)
                
                Text("/ month")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.renewlyTextSecondary)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(Color.renewlyCardBorder, lineWidth: 1)
            )
            .padding(.horizontal, 24)
            .padding(.bottom, 24)
            
            // Default Reminder notice
            HStack(spacing: 12) {
                Image(systemName: "bell.badge.fill")
                    .foregroundColor(.renewlyPrimary)
                    .font(.system(size: 20))
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Reminders set for 7 days & 1 day before")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.renewlyTextPrimary)
                    Text("Never get surprised by an auto-renewal charge.")
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(.renewlyTextSecondary)
                }
            }
            .padding(16)
            .background(Color.renewlyPrimaryLight.opacity(0.6))
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .padding(.horizontal, 24)
            
            Spacer()
            
            VStack(spacing: 12) {
                PrimaryButton(title: "Next") {
                    saveTrial()
                    withAnimation(.easeInOut(duration: 0.25)) {
                        currentStep = 5
                    }
                }
                
                Button("Back") {
                    withAnimation(.easeInOut(duration: 0.25)) {
                        currentStep = 3
                    }
                }
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(.renewlyPrimary)
                .padding(.vertical, 6)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 24)
        }
    }
    
    // MARK: - Confirmation Screen
    private var trialConfirmation: some View {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyyy"
        let endsStr = formatter.string(from: calculatedEndDate)
        let postPrice = Double(priceAfterTrialString.replacingOccurrences(of: ",", with: ".")) ?? 0.0
        
        return VStack(spacing: 0) {
            Spacer()
            
            ConfettiCheckmarkView()
                .padding(.bottom, 24)
            
            Text("🆓 Trial tracked")
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.renewlyTextPrimary)
                .padding(.bottom, 36)
            
            HStack(spacing: 16) {
                ServiceIconView(
                    name: name,
                    iconAssetName: selectedPreset?.iconAssetName,
                    sfSymbolName: selectedPreset?.sfSymbolName ?? "paintbrush.pointed.fill",
                    brandColorHex: selectedPreset?.brandColorHex ?? "00C4CC",
                    size: 48
                )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(name)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.renewlyTextPrimary)
                    
                    Text("Ends \(endsStr)")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.renewlyAttention)
                    
                    Text(String(format: "%@%.2f/month afterwards", currency, postPrice))
                        .font(.system(size: 13, weight: .regular))
                        .foregroundColor(.renewlyTextSecondary)
                }
                
                Spacer()
            }
            .padding(18)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(Color.renewlyCardBorder, lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.04), radius: 8, y: 2)
            .padding(.horizontal, 24)
            
            Spacer()
            
            PrimaryButton(title: "Done") {
                dismiss()
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 32)
        }
    }
    
    private func saveTrial() {
        let postPrice = Double(priceAfterTrialString.replacingOccurrences(of: ",", with: ".")) ?? 0.0
        let effectiveName = name.trimmingCharacters(in: .whitespaces).isEmpty ? "Free Trial" : name
        
        let newTrial = SubscriptionModel(
            name: effectiveName,
            iconAssetName: selectedPreset?.iconAssetName,
            sfSymbolName: selectedPreset?.sfSymbolName ?? "paintbrush.pointed.fill",
            brandColorHex: selectedPreset?.brandColorHex ?? "00C4CC",
            category: category,
            type: .trial,
            price: 0.0,
            currency: currency,
            billingFrequency: .monthly,
            startDate: startDate,
            nextRenewalDate: calculatedEndDate,
            hasUnknownRenewalDate: false,
            trialDurationDays: trialDurationDays,
            priceAfterTrial: postPrice,
            status: .active,
            reminderDays: reminderDays,
            notes: "\(trialDurationDays)-day free trial"
        )
        
        modelContext.insert(newTrial)
        try? modelContext.save()
        NotificationManager.shared.scheduleReminders(for: newTrial)
    }
}
