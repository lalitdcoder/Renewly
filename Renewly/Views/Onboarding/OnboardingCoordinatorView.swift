//
//  OnboardingCoordinatorView.swift
//  Renewly
//

import SwiftUI
import SwiftData

struct OnboardingCoordinatorView: View {
    @Environment(\.modelContext) private var modelContext
    @Binding var isOnboardingComplete: Bool
    
    @State private var currentStep = 0
    @State private var selectedItems: [FastSetupItem] = []
    
    var body: some View {
        ZStack {
            switch currentStep {
            case 0:
                WelcomeView {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        currentStep = 1
                    }
                }
                .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                
            case 1:
                FastSetupServicePickerView(
                    selectedItems: $selectedItems,
                    onContinue: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            currentStep = 2
                        }
                    },
                    onSkip: {
                        finishOnboardingWithoutItems()
                    }
                )
                .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                
            case 2:
                FastSetupConfirmView(
                    selectedItems: $selectedItems,
                    onQuickSetupComplete: {
                        saveSubscriptionsAndProceed()
                    },
                    onBack: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            currentStep = 1
                        }
                    }
                )
                .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                
            default:
                FastSetupSuccessView(
                    savedItems: selectedItems,
                    onFinish: {
                        finishOnboarding()
                    }
                )
                .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
            }
        }
    }
    
    private func saveSubscriptionsAndProceed() {
        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.impactOccurred()
        
        // Save items to SwiftData
        for item in selectedItems {
            let sub = item.toSubscriptionModel()
            modelContext.insert(sub)
            NotificationManager.shared.scheduleReminders(for: sub)
        }
        try? modelContext.save()
        
        withAnimation(.easeInOut(duration: 0.3)) {
            currentStep = 3
        }
    }
    
    private func finishOnboarding() {
        withAnimation(.easeInOut(duration: 0.4)) {
            UserPreferences.shared.hasCompletedOnboarding = true
            isOnboardingComplete = true
        }
    }
    
    private func finishOnboardingWithoutItems() {
        withAnimation(.easeInOut(duration: 0.4)) {
            UserPreferences.shared.hasCompletedOnboarding = true
            isOnboardingComplete = true
        }
    }
}
