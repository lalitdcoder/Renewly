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
                content.title = "Free Trial Ending Soon"
                if daysBefore == 0 {
                    content.body = "\(subscription.name) free trial ends today! Afterwards it's \(subscription.currency)\(String(format: "%.2f", subscription.priceAfterTrial ?? subscription.price))/month."
                } else if daysBefore == 1 {
                    content.body = "\(subscription.name) free trial ends tomorrow. Cancel today to avoid charges."
                } else {
                    content.body = "\(subscription.name) free trial ends in \(daysBefore) days."
                }
            } else {
                content.title = "Subscription Renewal"
                if daysBefore == 0 {
                    content.body = "\(subscription.name) renews today for \(subscription.currency)\(String(format: "%.2f", subscription.price))."
                } else if daysBefore == 1 {
                    content.body = "\(subscription.name) renews tomorrow for \(subscription.currency)\(String(format: "%.2f", subscription.price))."
                } else {
                    content.body = "\(subscription.name) renews in \(daysBefore) days (\(subscription.currency)\(String(format: "%.2f", subscription.price)))."
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
