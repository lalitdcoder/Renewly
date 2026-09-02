//
//  CalendarSyncManager.swift
//  Renewly
//

import Foundation
import EventKit
import SwiftUI

@Observable
final class CalendarSyncManager {
    static let shared = CalendarSyncManager()
    
    private let eventStore = EKEventStore()
    var authorizationStatus: EKAuthorizationStatus = .notDetermined
    var isSyncing: Bool = false
    
    private init() {
        self.authorizationStatus = EKEventStore.authorizationStatus(for: .event)
    }
    
    func checkStatus() {
        self.authorizationStatus = EKEventStore.authorizationStatus(for: .event)
    }
    
    @discardableResult
    func requestAccess() async -> Bool {
        do {
            var granted = false
            if #available(iOS 17.0, *) {
                granted = try await eventStore.requestWriteOnlyAccessToEvents()
            } else {
                granted = try await eventStore.requestAccess(to: .event)
            }
            await MainActor.run {
                self.authorizationStatus = EKEventStore.authorizationStatus(for: .event)
            }
            return granted
        } catch {
            print("Failed to request calendar access: \(error)")
            await MainActor.run {
                self.authorizationStatus = EKEventStore.authorizationStatus(for: .event)
            }
            return false
        }
    }
    
    // Add a single subscription renewal to Apple Calendar
    func addEvent(for subscription: SubscriptionModel) async -> (success: Bool, message: String) {
        guard let renewalDate = subscription.nextRenewalDate, !subscription.hasUnknownRenewalDate else {
            return (false, "Subscription does not have a set renewal date.")
        }
        
        let hasAccess = await requestAccess()
        guard hasAccess else {
            return (false, "Calendar permission was not granted. Please enable Calendar access in iOS Settings.")
        }
        
        let event = EKEvent(eventStore: eventStore)
        if subscription.type == .trial {
            event.title = "\(subscription.name) Free Trial Ends"
            if let post = subscription.priceAfterTrial {
                event.notes = "Free trial for \(subscription.name) ends today. Regular price afterwards: \(subscription.currency)\(String(format: "%.2f", post))/month. Tracked in Renewly."
            } else {
                event.notes = "Free trial for \(subscription.name) ends today. Tracked in Renewly."
            }
        } else {
            event.title = "\(subscription.name) Renewal (\(subscription.currency)\(String(format: "%.2f", subscription.price)))"
            event.notes = "\(subscription.name) \(subscription.billingFrequency.rawString.lowercased()) subscription renewal for \(subscription.currency)\(String(format: "%.2f", subscription.price)). Tracked in Renewly."
        }
        
        // All-day event on renewal date
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: renewalDate)
        event.startDate = startOfDay
        event.endDate = calendar.date(byAdding: .day, value: 1, to: startOfDay) ?? startOfDay
        event.isAllDay = true
        event.calendar = eventStore.defaultCalendarForNewEvents
        
        // Add alarm 1 day before at 9 AM
        let alarm = EKAlarm(relativeOffset: -86400) // 1 day before
        event.addAlarm(alarm)
        
        do {
            try eventStore.save(event, span: .thisEvent)
            return (true, "Added to Apple Calendar!")
        } catch {
            return (false, "Failed to save event to Calendar: \(error.localizedDescription)")
        }
    }
    
    // Sync all active subscriptions with renewal dates
    func syncAllEvents(subscriptions: [SubscriptionModel]) async -> (success: Bool, count: Int, message: String) {
        let hasAccess = await requestAccess()
        guard hasAccess else {
            return (false, 0, "Calendar permission was not granted. Please enable in Settings.")
        }
        
        let activeSubs = subscriptions.filter { $0.status == .active && $0.nextRenewalDate != nil && !$0.hasUnknownRenewalDate }
        var count = 0
        
        for sub in activeSubs {
            let result = await addEvent(for: sub)
            if result.success {
                count += 1
            }
        }
        
        return (true, count, "Successfully added \(count) renewal event\(count == 1 ? "" : "s") to your Calendar.")
    }
}
