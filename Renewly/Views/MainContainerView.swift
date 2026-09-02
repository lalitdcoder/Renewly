//
//  MainContainerView.swift
//  Renewly
//

import SwiftUI
import SwiftData

struct MainContainerView: View {
    @Environment(\.modelContext) private var modelContext
    
    @State private var selectedTab: AppTab = .home
    @State private var showQuickAddSheet = false
    @State private var showDetailedAddSheet = false
    @State private var showAddFreeTrialSheet = false
    @State private var selectedSubscriptionForDetail: SubscriptionModel?
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Tab Content
            Group {
                switch selectedTab {
                case .home:
                    HomeView(
                        selectedTab: $selectedTab,
                        onAddSubscription: {
                            showQuickAddSheet = true
                        },
                        onSelectSubscription: { sub in
                            selectedSubscriptionForDetail = sub
                        }
                    )
                case .subs:
                    SubscriptionsListView(
                        onAddSubscription: {
                            showQuickAddSheet = true
                        },
                        onAddFreeTrial: {
                            showAddFreeTrialSheet = true
                        },
                        onSelectSubscription: { sub in
                            selectedSubscriptionForDetail = sub
                        }
                    )
                case .calendar:
                    CalendarView()
                case .insights:
                    InsightsView(
                        onAddSubscription: {
                            showQuickAddSheet = true
                        },
                        onSelectSubscription: { sub in
                            selectedSubscriptionForDetail = sub
                        }
                    )
                case .more:
                    SettingsView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            // Custom Tab Bar
            CustomTabBar(selectedTab: $selectedTab)
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .sheet(isPresented: $showQuickAddSheet) {
            QuickAddSubscriptionSheet(
                onSwitchToDetailedAdd: {
                    showQuickAddSheet = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        showDetailedAddSheet = true
                    }
                }
            )
        }
        .sheet(isPresented: $showDetailedAddSheet) {
            AddSubscriptionFlowView()
        }
        .sheet(isPresented: $showAddFreeTrialSheet) {
            AddFreeTrialFlowView()
        }
        .sheet(item: $selectedSubscriptionForDetail) { sub in
            NavigationStack {
                SubscriptionDetailView(subscription: sub)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Close") {
                                selectedSubscriptionForDetail = nil
                            }
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(.renewlyPrimary)
                        }
                    }
            }
        }
        .onAppear {
            SampleDataLoader.seedIfNeeded(modelContext: modelContext)
        }
    }
}
