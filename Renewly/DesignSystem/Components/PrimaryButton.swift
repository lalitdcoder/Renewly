//
//  PrimaryButton.swift
//  Renewly
//

import SwiftUI

struct PrimaryButton: View {
    let title: String
    var icon: String? = nil
    var isEnabled: Bool = true
    var isLoading: Bool = false
    let action: () -> Void
    
    var body: some View {
        Button(action: {
            guard isEnabled && !isLoading else { return }
            let impact = UIImpactFeedbackGenerator(style: .medium)
            impact.impactOccurred()
            action()
        }) {
            HStack(spacing: 8) {
                if isLoading {
                    ProgressView()
                        .tint(.white)
                } else {
                    if let icon = icon {
                        Image(systemName: icon)
                            .font(.system(size: 16, weight: .semibold))
                    }
                    Text(title)
                        .font(.system(size: 16, weight: .semibold))
                }
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 52)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(isEnabled ? Color.renewlyPrimary : Color.renewlyPrimary.opacity(0.4))
            )
            .shadow(color: isEnabled ? Color.renewlyPrimary.opacity(0.25) : .clear, radius: 10, y: 4)
        }
        .disabled(!isEnabled || isLoading)
        .buttonStyle(SpringBounceButtonStyle())
    }
}

struct SecondaryButton: View {
    let title: String
    var icon: String? = nil
    var color: Color = .renewlyPrimary
    let action: () -> Void
    
    var body: some View {
        Button(action: {
            let impact = UIImpactFeedbackGenerator(style: .light)
            impact.impactOccurred()
            action()
        }) {
            HStack(spacing: 6) {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: 14, weight: .medium))
                }
                Text(title)
                    .font(.system(size: 15, weight: .medium))
            }
            .foregroundColor(color)
            .padding(.vertical, 10)
            .padding(.horizontal, 16)
        }
        .buttonStyle(SpringBounceButtonStyle())
    }
}

struct SpringBounceButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .animation(.spring(response: 0.25, dampingFraction: 0.7), value: configuration.isPressed)
    }
}
