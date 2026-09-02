//
//  SubscriptionsListView.swift
//  Renewly
//

import SwiftUI
import SwiftData

enum SubscriptionsFilter: String, CaseIterable, Identifiable {
    case all = "All"
    case active = "Active"
    case trials = "Trials"
    case paused = "Paused"
    case cancelled = "Cancelled"
    
    var id: String { rawValue }
}

struct SubscriptionsListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var allSubscriptions: [SubscriptionModel]
    
    let onAddSubscription: () -> Void
    let onAddFreeTrial: () -> Void
    let onSelectSubscription: (SubscriptionModel) -> Void
    
    @State private var selectedFilter: SubscriptionsFilter = .all
    @State private var searchText: String = ""
    @State private var showAddMenuSheet = false
    
    private var filteredSubscriptions: [SubscriptionModel] {
        var items = allSubscriptions
        
        // Filter by tab chip
        switch selectedFilter {
        case .all:
            break
        case .active:
            items = items.filter { $0.status == .active && $0.type == .subscription }
        case .trials:
            items = items.filter { $0.type == .trial }
        case .paused:
            items = items.filter { $0.status == .paused }
        case .cancelled:
            items = items.filter { $0.status == .cancelled || $0.status == .expired }
        }
        
        // Filter by search query
        let query = searchText.trimmingCharacters(in: .whitespaces)
        if !query.isEmpty {
            items = items.filter {
                $0.name.localizedCaseInsensitiveContains(query) ||
                $0.categoryRaw.localizedCaseInsensitiveContains(query) ||
                $0.status.displayName.localizedCaseInsensitiveContains(query)
            }
        }
        
        // Sort chronologically by renewal
        return items.sorted {
            if $0.status == .active && $1.status != .active { return true }
            if $0.status != .active && $1.status == .active { return false }
            return ($0.nextRenewalDate ?? Date.distantFuture) < ($1.nextRenewalDate ?? Date.distantFuture)
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Header matching Screen 05: "Subscriptions" + "+"
                HStack {
                    Spacer()
                    Text("Subscriptions")
                        .font(.system(size: 17, weight: .bold))
                        .foregroundColor(.renewlyTextPrimary)
                    Spacer()
                }
                .overlay(
                    HStack {
                        Spacer()
                        Button(action: {
                            showAddMenuSheet = true
                        }) {
                            Image(systemName: "plus")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.renewlyPrimary)
                                .frame(width: 36, height: 36)
                        }
                    },
                    alignment: .trailing
                )
                .padding(.horizontal, 20)
                .padding(.top, 12)
                .padding(.bottom, 10)
                
                // Search Bar matching Screen 05
                HStack(spacing: 10) {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.renewlyTextMuted)
                        .font(.system(size: 15))
                    
                    TextField("Search subscriptions, categories...", text: $searchText)
                        .font(.system(size: 15))
                        .foregroundColor(.renewlyTextPrimary)
                    
                    if !searchText.isEmpty {
                        Button(action: { searchText = "" }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.renewlyTextMuted)
                                .font(.system(size: 14))
                        }
                    }
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(Color(hex: "F2F2F6"))
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                .padding(.horizontal, 24)
                .padding(.bottom, 12)
                
                // Horizontally Scrollable Filter Chips with Counts
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(SubscriptionsFilter.allCases) { filter in
                            let count: Int = {
                                switch filter {
                                case .all: return allSubscriptions.count
                                case .active: return allSubscriptions.filter { $0.status == .active && $0.type == .subscription }.count
                                case .trials: return allSubscriptions.filter { $0.type == .trial }.count
                                case .paused: return allSubscriptions.filter { $0.status == .paused }.count
                                case .cancelled: return allSubscriptions.filter { $0.status == .cancelled || $0.status == .expired }.count
                                }
                            }()
                            
                            FilterChip(
                                title: filter.rawValue,
                                isSelected: selectedFilter == filter,
                                count: count
                            ) {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                    selectedFilter = filter
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                }
                .padding(.bottom, 14)
                
                // Subscriptions List
                if filteredSubscriptions.isEmpty {
                    VStack(spacing: 14) {
                        Spacer(minLength: 40)
                        
                        ZStack {
                            Circle()
                                .fill(Color(hex: "F2F2F7"))
                                .frame(width: 72, height: 72)
                            
                            Image(systemName: selectedFilter == .trials ? "gift" : "magnifyingglass")
                                .font(.system(size: 30))
                                .foregroundColor(.renewlyTextMuted)
                        }
                        
                        Text(emptyStateTitle)
                            .font(.system(size: 17, weight: .bold))
                            .foregroundColor(.renewlyTextPrimary)
                        
                        Text(emptyStateMessage)
                            .font(.system(size: 14))
                            .foregroundColor(.renewlyTextSecondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 32)
                        
                        if !searchText.isEmpty || selectedFilter != .all {
                            Button(action: {
                                withAnimation {
                                    searchText = ""
                                    selectedFilter = .all
                                }
                            }) {
                                Text("Clear Filters")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.renewlyPrimary)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(Color.renewlyPrimaryLight)
                                    .clipShape(Capsule())
                            }
                            .padding(.top, 6)
                        } else if selectedFilter == .trials {
                            PrimaryButton(title: "+ Add Free Trial", action: onAddFreeTrial)
                                .padding(.horizontal, 32)
                                .padding(.top, 8)
                        }
                        
                        Spacer(minLength: 40)
                    }
                } else {
                    ScrollView(showsIndicators: false) {
                        LazyVStack(spacing: 12) {
                            ForEach(filteredSubscriptions) { sub in
                                SubscriptionCard(subscription: sub) {
                                    onSelectSubscription(sub)
                                }
                            }
                        }
                        .padding(.horizontal, 24)
                        .padding(.bottom, 24)
                    }
                }
            }
            .background(Color.renewlyBackground.ignoresSafeArea())
            .confirmationDialog("Add to Renewly", isPresented: $showAddMenuSheet, titleVisibility: .visible) {
                Button("Add Subscription") {
                    onAddSubscription()
                }
                Button("Add Free Trial") {
                    onAddFreeTrial()
                }
                Button("Cancel", role: .cancel) {}
            }
        }
    }
    
    private var emptyStateTitle: String {
        if !searchText.isEmpty {
            return "No results found"
        }
        switch selectedFilter {
        case .all: return "No subscriptions yet"
        case .active: return "No active subscriptions"
        case .trials: return "No active trials"
        case .paused: return "No paused subscriptions"
        case .cancelled: return "No cancelled subscriptions"
        }
    }
    
    private var emptyStateMessage: String {
        if !searchText.isEmpty {
            return "Try searching for a different service name or category."
        }
        switch selectedFilter {
        case .all: return "Add your first subscription or trial to start tracking."
        case .active: return "You don't have any active subscriptions."
        case .trials: return "Start tracking a free trial and we'll remind you before it ends."
        case .paused: return "Subscriptions you pause will appear here."
        case .cancelled: return "Subscriptions you cancel will appear here for your records."
        }
    }
}
