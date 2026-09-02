//
//  FastSetupServicePickerView.swift
//  Renewly
//

import SwiftUI

struct FastSetupServicePickerView: View {
    @Binding var selectedItems: [FastSetupItem]
    let onContinue: () -> Void
    let onSkip: () -> Void
    
    @State private var searchText = ""
    @State private var showManualAddAlert = false
    @State private var manualServiceName = ""
    
    private var allPresets: [ServicePreset] {
        ServicePreset.allPresets
    }
    
    private var filteredPresets: [ServicePreset] {
        if searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return allPresets
        }
        return allPresets.filter {
            $0.name.localizedCaseInsensitiveContains(searchText) ||
            $0.category.rawValue.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    private func isSelected(_ preset: ServicePreset) -> Bool {
        selectedItems.contains { $0.name.lowercased() == preset.name.lowercased() }
    }
    
    private func toggleSelection(_ preset: ServicePreset) {
        let impact = UIImpactFeedbackGenerator(style: .light)
        impact.impactOccurred()
        
        withAnimation(.spring(response: 0.25, dampingFraction: 0.75)) {
            if let index = selectedItems.firstIndex(where: { $0.name.lowercased() == preset.name.lowercased() }) {
                selectedItems.remove(at: index)
            } else {
                let item = FastSetupItem(from: preset, currency: UserPreferences.shared.currency.rawValue)
                selectedItems.append(item)
            }
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Top Header & Subtitle
            VStack(alignment: .leading, spacing: 8) {
                Text("Let's add your subscriptions")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.renewlyTextPrimary)
                
                Text("Add the subscriptions and free trials you want to keep track of. You can always add more later.")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.renewlyTextSecondary)
                    .lineSpacing(2)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 24)
            .padding(.top, 16)
            .padding(.bottom, 14)
            
            // Search Input
            HStack(spacing: 10) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.renewlyTextMuted)
                
                TextField("Search subscriptions (e.g. Netflix, Spotify)", text: $searchText)
                    .font(.system(size: 15))
                    .foregroundColor(.renewlyTextPrimary)
                
                if !searchText.isEmpty {
                    Button(action: { searchText = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 16))
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
            .padding(.horizontal, 24)
            .padding(.bottom, 14)
            
            // Scrollable Grid of Services
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 14) {
                    if filteredPresets.isEmpty {
                        // Not found empty search state
                        VStack(spacing: 14) {
                            Text("Can't find \"\(searchText)\"?")
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(.renewlyTextPrimary)
                            
                            Button(action: {
                                manualServiceName = searchText
                                showManualAddAlert = true
                            }) {
                                HStack(spacing: 6) {
                                    Image(systemName: "plus.circle.fill")
                                    Text("Add \"\(searchText)\" manually")
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
                            Text(searchText.isEmpty ? "Popular Services" : "Matching Services")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(.renewlyTextSecondary)
                                .textCase(.uppercase)
                            
                            Spacer()
                        }
                        .padding(.horizontal, 24)
                        
                        LazyVGrid(columns: [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)], spacing: 12) {
                            ForEach(filteredPresets) { preset in
                                let selected = isSelected(preset)
                                
                                Button(action: {
                                    toggleSelection(preset)
                                }) {
                                    VStack(alignment: .leading, spacing: 10) {
                                        HStack {
                                            ServiceIconView(
                                                name: preset.name,
                                                iconAssetName: preset.iconAssetName,
                                                sfSymbolName: preset.sfSymbolName,
                                                brandColorHex: preset.brandColorHex,
                                                size: 38,
                                                cornerRadius: 10
                                            )
                                            
                                            Spacer()
                                            
                                            ZStack {
                                                Circle()
                                                    .stroke(selected ? Color.renewlyPrimary : Color.renewlyCardBorder, lineWidth: 1.5)
                                                    .frame(width: 22, height: 22)
                                                
                                                if selected {
                                                    Circle()
                                                        .fill(Color.renewlyPrimary)
                                                        .frame(width: 22, height: 22)
                                                    
                                                    Image(systemName: "checkmark")
                                                        .font(.system(size: 11, weight: .bold))
                                                        .foregroundColor(.white)
                                                }
                                            }
                                        }
                                        
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(preset.name)
                                                .font(.system(size: 14, weight: .bold))
                                                .foregroundColor(.renewlyTextPrimary)
                                                .lineLimit(1)
                                            
                                            Text(preset.defaultTrialDays > 0 ? "\(preset.defaultTrialDays)-day free trial" : String(format: "%@%.2f/mo", UserPreferences.shared.currency.rawValue, preset.defaultPrice))
                                                .font(.system(size: 11, weight: .medium))
                                                .foregroundColor(selected ? Color.renewlyPrimary : Color.renewlyTextSecondary)
                                        }
                                    }
                                    .padding(12)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(selected ? Color.renewlyPrimaryUltraLight : Color.white)
                                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                                            .stroke(selected ? Color.renewlyPrimary : Color.renewlyCardBorder, lineWidth: selected ? 1.8 : 1)
                                    )
                                    .shadow(color: selected ? Color.renewlyPrimary.opacity(0.1) : Color.black.opacity(0.02), radius: 3, y: 1)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal, 24)
                        
                        // "Can't find it?" link at the bottom
                        HStack {
                            Spacer()
                            Button(action: {
                                manualServiceName = ""
                                showManualAddAlert = true
                            }) {
                                HStack(spacing: 4) {
                                    Image(systemName: "plus")
                                        .font(.system(size: 12, weight: .bold))
                                    Text("Add custom subscription")
                                        .font(.system(size: 13, weight: .semibold))
                                }
                                .foregroundColor(.renewlyPrimary)
                                .padding(.vertical, 8)
                            }
                            Spacer()
                        }
                        .padding(.top, 6)
                    }
                }
                .padding(.bottom, 90)
            }
            
            // Bottom Action Bar
            VStack(spacing: 8) {
                PrimaryButton(
                    title: selectedItems.isEmpty ? "Continue" : "Continue (\(selectedItems.count) selected)",
                    action: {
                        if selectedItems.isEmpty {
                            onSkip()
                        } else {
                            onContinue()
                        }
                    }
                )
                
                Button(action: onSkip) {
                    Text("I'll do this later")
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
        .alert("Add Custom Subscription", isPresented: $showManualAddAlert) {
            TextField("Service name (e.g. Gym, VPN)", text: $manualServiceName)
            Button("Cancel", role: .cancel) {}
            Button("Add") {
                let trimmed = manualServiceName.trimmingCharacters(in: .whitespacesAndNewlines)
                if !trimmed.isEmpty {
                    let newItem = FastSetupItem(customName: trimmed, currency: UserPreferences.shared.currency.rawValue)
                    selectedItems.append(newItem)
                }
            }
        } message: {
            Text("Enter the name of your subscription.")
        }
    }
}
