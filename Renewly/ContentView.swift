//
//  ContentView.swift
//  Renewly
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var userPreferences = UserPreferences.shared
    @State private var isOnboardingComplete: Bool = UserPreferences.shared.hasCompletedOnboarding
    
    var body: some View {
        Group {
            if isOnboardingComplete {
                MainContainerView()
            } else {
                OnboardingCoordinatorView(isOnboardingComplete: $isOnboardingComplete)
            }
        }
        .preferredColorScheme(colorScheme)
    }
    
    private var colorScheme: ColorScheme? {
        switch userPreferences.appearance {
        case .system: return nil
        case .light: return .light
        case .dark: return .dark
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: SubscriptionModel.self, inMemory: true)
}
