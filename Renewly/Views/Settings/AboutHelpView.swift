//
//  AboutHelpView.swift
//  Renewly
//

import SwiftUI

struct AboutHelpView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            List {
                Section("About Renewly") {
                    Text("Renewly is a simple, private subscription and free-trial tracker. Know what renews and never forget a free trial again.")
                        .font(.system(size: 14))
                        .foregroundColor(.renewlyTextSecondary)
                }
                
                Section("Frequently Asked Questions") {
                    DisclosureGroup("Does Renewly connect to my bank account?") {
                        Text("No. Renewly does not access your bank or financial accounts. All subscriptions are tracked locally on your device for total privacy.")
                            .font(.system(size: 13))
                            .foregroundColor(.renewlyTextSecondary)
                            .padding(.vertical, 4)
                    }
                    
                    DisclosureGroup("How do reminders work?") {
                        Text("Renewly uses local iOS notifications to alert you before your subscription renews or your free trial expires (e.g. 7 days, 3 days, or 1 day prior).")
                            .font(.system(size: 13))
                            .foregroundColor(.renewlyTextSecondary)
                            .padding(.vertical, 4)
                    }
                    
                    DisclosureGroup("What happens if I don't know my renewal date?") {
                        Text("You can tap 'I don't know' when adding a subscription. It will still be tracked and included in your monthly spending estimates.")
                            .font(.system(size: 13))
                            .foregroundColor(.renewlyTextSecondary)
                            .padding(.vertical, 4)
                    }
                }
                
                Section("Privacy & Terms") {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Privacy Policy")
                            .font(.system(size: 15, weight: .semibold))
                        Text("We believe your financial data belongs to you. All subscription data is stored solely on your device. We do not sell or track your personal information.")
                            .font(.system(size: 13))
                            .foregroundColor(.renewlyTextSecondary)
                    }
                    .padding(.vertical, 4)
                    
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Terms of Service")
                            .font(.system(size: 15, weight: .semibold))
                        Text("Renewly is provided for personal informational and reminder purposes. Always verify cancellation terms directly with your service provider.")
                            .font(.system(size: 13))
                            .foregroundColor(.renewlyTextSecondary)
                    }
                    .padding(.vertical, 4)
                }
            }
            .navigationTitle("Help & Info")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.renewlyPrimary)
                }
            }
        }
    }
}
