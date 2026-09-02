//
//  NotificationManager.swift
//  Renewly
//

import Foundation
import UserNotifications

@Observable
final class NotificationManager {
    static let shared = NotificationManager()
    
    var authorizationStatus: UNAuthorizationStatus = .notDetermined
    
    private init() {
        Task {
            await checkAuthorizationStatus()
        }
    }
    
    func checkAuthorizationStatus() async {
        let settings = await UNUserNotificationCenter.current().notificationSettings()
        await MainActor.run {
            self.authorizationStatus = settings.authorizationStatus
        }
    }
    
    @discardableResult
    func requestAuthorization() async -> Bool {
        do {
            let granted = try await UNUserNotificationCenter.current().requestAuthorization(
                options: [.alert, .sound, .badge]
            )
            await checkAuthorizationStatus()
            return granted
        } catch {
            print("Failed to request notification authorization: \(error)")
            await checkAuthorizationStatus()
            return false
        }
    }
    
    func scheduleReminders(for subscription: SubscriptionModel) {
        guard subscription.status == .active,
              let renewalDate = subscription.nextRenewalDate,
              !subscription.hasUnknownRenewalDate else {
            cancelReminders(for: subscription)
            return
        }
        
        // Remove existing notifications first
        cancelReminders(for: subscription)
        
        let center = UNUserNotificationCenter.current()
        let calendar = Calendar.current
        
        for daysBefore in subscription.reminderDays {
            guard let triggerDate = calendar.date(byAdding: .day, value: -daysBefore, to: renewalDate) else {
                continue
            }
            
            // Adjust to the user's preferred reminder time
            let timeComponents = calendar.dateComponents([.hour, .minute], from: subscription.reminderTime)
            var dateComponents = calendar.dateComponents([.year, .month, .day], from: triggerDate)
            dateComponents.hour = timeComponents.hour ?? 9
            dateComponents.minute = timeComponents.minute ?? 0
            dateComponents.second = 0
            
            guard let scheduledDateTime = calendar.date(from: dateComponents),
                  scheduledDateTime > Date() else {
                continue
            }
            
            let content = UNMutableNotificationContent()
            content.sound = .default
            
            if subscription.type == .trial {
                content.title = "Renewly"
                if daysBefore == 0 {
                    content.body = "Your \(subscription.name) trial ends today."
                } else if daysBefore == 1 {
                    content.body = "Your \(subscription.name) trial ends tomorrow."
                } else {
                    content.body = "Your \(subscription.name) trial ends in \(daysBefore) days."
                }
            } else {
                content.title = "Renewly"
                if daysBefore == 0 {
                    content.body = String(format: "%@ renews today · %@%.2f", subscription.name, subscription.currency, subscription.price)
                } else if daysBefore == 1 {
                    content.body = String(format: "%@ renews tomorrow · %@%.2f", subscription.name, subscription.currency, subscription.price)
                } else {
                    content.body = String(format: "%@ renews in %d days · %@%.2f", subscription.name, daysBefore, subscription.currency, subscription.price)
                }
            }
            
            content.userInfo = [
                "subscriptionId": subscription.id.uuidString,
                "subscriptionName": subscription.name
            ]
            
            let triggerComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: scheduledDateTime)
            let trigger = UNCalendarNotificationTrigger(dateMatching: triggerComponents, repeats: false)
            
            let identifier = "\(subscription.id.uuidString)_\(daysBefore)"
            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
            
            center.add(request) { error in
                if let error = error {
                    print("Error scheduling notification for \(subscription.name): \(error)")
                }
            }
        }
    }
    
    func scheduleAll(subscriptions: [SubscriptionModel]) {
        for subscription in subscriptions {
            scheduleReminders(for: subscription)
        }
    }
    
    func cancelReminders(for subscription: SubscriptionModel) {
        let center = UNUserNotificationCenter.current()
        center.getPendingNotificationRequests { requests in
            let idsToRemove = requests
                .filter { $0.identifier.starts(with: subscription.id.uuidString) }
                .map { $0.identifier }
            center.removePendingNotificationRequests(withIdentifiers: idsToRemove)
        }
    }
    
    func cancelAllReminders() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}
