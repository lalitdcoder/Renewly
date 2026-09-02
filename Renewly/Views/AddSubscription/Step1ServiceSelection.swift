//
//  Step1ServiceSelection.swift
//  Renewly
//

import SwiftUI

struct Step1ServiceSelection: View {
    @Binding var selectedPreset: ServicePreset?
    @Binding var customName: String
    @Binding var selectedCategory: SubscriptionCategory
    let onNext: () -> Void
    
    @State private var searchText = ""
    @State private var showAllServices = false
    
    private var filteredPresets: [ServicePreset] {
        if searchText.trimmingCharacters(in: .whitespaces).isEmpty {
            return showAllServices ? ServicePreset.allPresets : ServicePreset.popularSubscriptions
        }
        return ServicePreset.allPresets.filter {
            $0.name.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    var isNextEnabled: Bool {
        selectedPreset != nil || !customName.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Step header
            VStack(alignment: .leading, spacing: 6) {
                Text("Step 1 of 5")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.renewlyTextMuted)
                
                Text("What are you\nsubscribed to?")
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
                    .font(.system(size: 16))
                
                TextField("Search for a service", text: $searchText)
                    .font(.system(size: 15))
                    .foregroundColor(.renewlyTextPrimary)
                    .onChange(of: searchText) { _, newValue in
                        if !newValue.isEmpty {
                            customName = newValue
                        }
                    }
                
                if !searchText.isEmpty {
                    Button(action: { searchText = ""; customName = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.renewlyTextMuted)
                    }
                }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 11)
            .background(Color(hex: "F2F2F6"))
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            .padding(.horizontal, 24)
            .padding(.bottom, 20)
            
            // Popular Grid / Search Results
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
                        ForEach(filteredPresets) { preset in
                            let isSelected = selectedPreset?.id == preset.id
                            
                            Button(action: {
                                let impact = UIImpactFeedbackGenerator(style: .light)
                                impact.impactOccurred()
                                selectedPreset = preset
                                customName = preset.name
                                selectedCategory = preset.category
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
                                        .multilineTextAlignment(.center)
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
                    
                    // Show More Button
                    if searchText.isEmpty && !showAllServices {
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.25)) {
                                showAllServices = true
                            }
                        }) {
                            Text("Show more")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.renewlyTextPrimary)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(Color.white)
                                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                                        .stroke(Color.renewlyCardBorder, lineWidth: 1)
                                )
                        }
                        .padding(.horizontal, 24)
                        .padding(.top, 4)
                    }
                }
                .padding(.bottom, 20)
            }
            
            Spacer(minLength: 8)
            
            // Bottom Action
            PrimaryButton(title: "Next", isEnabled: isNextEnabled, action: onNext)
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
        }
    }
}
