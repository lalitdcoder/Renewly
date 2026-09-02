//
//  RenewlyTests.swift
//  RenewlyTests
//

import Testing
import Foundation
@testable import Renewly

struct RenewlyTests {

    @Test func testSpendingCalculations() throws {
        let calendar = Calendar.current
        let today = Date()
        
        let sub1 = SubscriptionModel(
            name: "Netflix",
            type: .subscription,
            price: 17.99,
            currency: "£",
            billingFrequency: .monthly,
            nextRenewalDate: calendar.date(byAdding: .day, value: 3, to: today),
            status: .active
        )
        
        let sub2 = SubscriptionModel(
            name: "Yearly Service",
            type: .subscription,
            price: 120.00,
            currency: "£",
            billingFrequency: .yearly,
            nextRenewalDate: calendar.date(byAdding: .day, value: 20, to: today),
            status: .active
        )
        
        let sub3Paused = SubscriptionModel(
            name: "Paused Service",
            type: .subscription,
            price: 20.00,
            currency: "£",
            billingFrequency: .monthly,
            nextRenewalDate: calendar.date(byAdding: .day, value: 10, to: today),
            status: .paused
        )
        
        let trial = SubscriptionModel(
            name: "Canva Trial",
            type: .trial,
            price: 0.00,
            currency: "£",
            billingFrequency: .monthly,
            nextRenewalDate: calendar.date(byAdding: .day, value: 2, to: today),
            priceAfterTrial: 12.99,
            status: .active
        )
        
        let all = [sub1, sub2, sub3Paused, trial]
        
        // Monthly: 17.99 + (120 / 12 = 10.00) = 27.99
        let monthly = SpendingCalculator.totalMonthlySpending(subscriptions: all)
        #expect(abs(monthly - 27.99) < 0.01)
        
        // Yearly: (17.99 * 12 = 215.88) + 120.00 = 335.88
        let yearly = SpendingCalculator.totalYearlySpending(subscriptions: all)
        #expect(abs(yearly - 335.88) < 0.01)
    }

    @Test func testMockupSampleDataSpendingMatchesTarget() throws {
        let sampleItems = SampleDataLoader.createSampleSubscriptions()
        let monthlyTotal = SpendingCalculator.totalMonthlySpending(subscriptions: sampleItems)
        let yearlyTotal = SpendingCalculator.totalYearlySpending(subscriptions: sampleItems)
        
        // Target in mockup: £63.94 monthly, £767.28 yearly
        #expect(abs(monthlyTotal - 63.94) < 0.01)
        #expect(abs(yearlyTotal - 767.28) < 0.01)
    }

    @Test func testCountdownAndBadges() throws {
        let calendar = Calendar.current
        let today = Date()
        
        let in3Days = calendar.date(byAdding: .day, value: 3, to: today)
        let sub = SubscriptionModel(
            name: "Netflix",
            type: .subscription,
            price: 17.99,
            nextRenewalDate: in3Days
        )
        
        let days = sub.daysUntilRenewal(from: today)
        #expect(days == 3)
        #expect(sub.renewalBadgeText(from: today) == "3 days")
        #expect(sub.statusSubtitle(from: today) == "Renews in 3 days")
        #expect(sub.isUrgent == true)
    }

    @Test func testDataExport() throws {
        let sampleItems = SampleDataLoader.createSampleSubscriptions()
        
        let jsonData = DataExportManager.exportToJSON(subscriptions: sampleItems)
        #expect(jsonData != nil)
        #expect((jsonData?.count ?? 0) > 100)
        
        let csvString = DataExportManager.exportToCSV(subscriptions: sampleItems)
        #expect(csvString.contains("Netflix"))
        #expect(csvString.contains("Spotify"))
        #expect(csvString.contains("Canva"))
    }
    
    @Test func testInsightsCategoryBreakdown() throws {
        let sub1 = SubscriptionModel(
            name: "Netflix",
            category: .entertainment,
            type: .subscription,
            price: 20.00,
            billingFrequency: .monthly,
            status: .active
        )
        let sub2 = SubscriptionModel(
            name: "Spotify",
            category: .music,
            type: .subscription,
            price: 10.00,
            billingFrequency: .monthly,
            status: .active
        )
        let sub3 = SubscriptionModel(
            name: "Disney+",
            category: .entertainment,
            type: .subscription,
            price: 10.00,
            billingFrequency: .monthly,
            status: .active
        )
        
        let categories = InsightsCalculator.calculateCategoryBreakdown(subscriptions: [sub1, sub2, sub3])
        #expect(categories.count == 2)
        
        // Entertainment: £30 / £40 = 75%
        let ent = categories.first { $0.category == .entertainment }
        #expect(ent != nil)
        #expect(ent?.monthlyAmount == 30.00)
        #expect(ent?.percentage == 75.0)
        
        // Music: £10 / £40 = 25%
        let music = categories.first { $0.category == .music }
        #expect(music != nil)
        #expect(music?.monthlyAmount == 10.00)
        #expect(music?.percentage == 25.0)
    }
    
    @Test func testInsightsSavingsCalculation() throws {
        let active = SubscriptionModel(
            name: "Netflix",
            type: .subscription,
            price: 10.00,
            billingFrequency: .monthly,
            status: .active
        )
        let cancelledMonthly = SubscriptionModel(
            name: "Gym",
            type: .subscription,
            price: 30.00,
            billingFrequency: .monthly,
            status: .cancelled
        )
        let stoppedTrial = SubscriptionModel(
            name: "Audible Trial",
            type: .trial,
            price: 0.00,
            priceAfterTrial: 8.00,
            status: .cancelled
        )
        
        let savings = InsightsCalculator.calculateSavings(subscriptions: [active, cancelledMonthly, stoppedTrial])
        #expect(savings.hasSavings == true)
        #expect(savings.cancelledCount == 1)
        #expect(savings.stoppedTrialCount == 1)
        
        // Cancelled annual savings: 30 * 12 = 360
        #expect(abs(savings.cancelledSubscriptionsAnnualSavings - 360.00) < 0.01)
        // Stopped trial annual savings: 8 * 12 = 96
        #expect(abs(savings.stoppedTrialsSavings - 96.00) < 0.01)
        // Total: 456
        #expect(abs(savings.totalEstimatedAnnualSavings - 456.00) < 0.01)
    }
    
    @Test func testInsightsBiggestSubscriptionsSorting() throws {
        let yearlyExp = SubscriptionModel(
            name: "Adobe Cloud",
            type: .subscription,
            price: 240.00,
            billingFrequency: .yearly, // £20/mo
            status: .active
        )
        let monthlyCheap = SubscriptionModel(
            name: "iCloud",
            type: .subscription,
            price: 2.99,
            billingFrequency: .monthly, // £2.99/mo
            status: .active
        )
        let monthlyMed = SubscriptionModel(
            name: "Netflix",
            type: .subscription,
            price: 17.99,
            billingFrequency: .monthly, // £17.99/mo
            status: .active
        )
        
        let biggest = InsightsCalculator.calculateBiggestSubscriptions(subscriptions: [monthlyCheap, yearlyExp, monthlyMed])
        #expect(biggest.count == 3)
        #expect(biggest[0].name == "Adobe Cloud") // £20.00/mo
        #expect(biggest[1].name == "Netflix")     // £17.99/mo
        #expect(biggest[2].name == "iCloud")      // £2.99/mo
    }
    
    @Test func testFastSetupSmartDefaultsAndConversion() throws {
        let netflixPreset = ServicePreset.popularSubscriptions[0]
        let spotifyPreset = ServicePreset.popularSubscriptions[1]
        
        let item1 = FastSetupItem(from: netflixPreset, currency: "£")
        let item2 = FastSetupItem(from: spotifyPreset, currency: "£")
        
        #expect(item1.name == "Netflix")
        #expect(item1.price == 17.99)
        #expect(item1.category == .entertainment)
        #expect(item1.hasUnknownRenewalDate == false)
        
        #expect(item2.name == "Spotify")
        #expect(item2.price == 11.99)
        #expect(item2.category == .music)
        
        let sub1 = item1.toSubscriptionModel()
        let sub2 = item2.toSubscriptionModel()
        
        #expect(sub1.name == "Netflix")
        #expect(sub1.price == 17.99)
        #expect(sub1.status == .active)
        #expect(sub2.name == "Spotify")
        #expect(sub2.price == 11.99)
        #expect(sub2.status == .active)
    }
    
    @Test func testFastSetupUnknownRenewalDate() throws {
        var custom = FastSetupItem(customName: "Local Newspaper", currency: "£")
        #expect(custom.hasUnknownRenewalDate == true)
        
        let sub = custom.toSubscriptionModel()
        #expect(sub.hasUnknownRenewalDate == true)
        #expect(sub.nextRenewalDate == nil)
        #expect(sub.renewalBadgeText() == "Not set")
    }
}
