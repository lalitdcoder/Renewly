//
//  HowItWorksView.swift
//  Renewly
//

import SwiftUI

struct HowItWorksView: View {
    let onContinue: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            Text("How it works")
                .font(.system(size: 24, weight: .bold, design: .default))
                .foregroundColor(.renewlyTextPrimary)
                .padding(.top, 40)
                .padding(.bottom, 28)
            
            // 3 Instruction Cards matching Screen 02
            VStack(spacing: 16) {
                InstructionCard(
                    iconBackgroundColor: Color.renewlyPrimary,
                    iconSymbol: "plus",
                    title: "Add",
                    description: "Add a subscription in seconds."
                )
                
                InstructionCard(
                    iconBackgroundColor: Color(hex: "00C288"),
                    iconSymbol: "eye.fill",
                    title: "Track",
                    description: "See what you're paying and when."
                )
                
                InstructionCard(
                    iconBackgroundColor: Color(hex: "FF9500"),
                    iconSymbol: "bell.fill",
                    title: "Remember",
                    description: "We'll remind you before it renews."
                )
            }
            .padding(.horizontal, 24)
            
            Spacer()
            
            // Bottom Action & Dots
            VStack(spacing: 20) {
                PrimaryButton(title: "Continue", action: onContinue)
                
                // Page Indicator Dots
                HStack(spacing: 8) {
                    Circle().fill(Color(hex: "E0E0E6")).frame(width: 7, height: 7)
                    Circle().fill(Color.renewlyPrimary).frame(width: 7, height: 7)
                    Circle().fill(Color(hex: "E0E0E6")).frame(width: 7, height: 7)
                    Circle().fill(Color(hex: "E0E0E6")).frame(width: 7, height: 7)
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 32)
        }
        .background(Color.renewlyBackground.ignoresSafeArea())
    }
}

struct InstructionCard: View {
    let iconBackgroundColor: Color
    let iconSymbol: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(iconBackgroundColor)
                    .frame(width: 48, height: 48)
                
                Image(systemName: iconSymbol)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
            }
            
            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.renewlyTextPrimary)
                
                Text(description)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.renewlyTextSecondary)
            }
            
            Spacer()
        }
        .padding(16)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(Color.renewlyCardBorder, lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.03), radius: 8, y: 2)
    }
}
