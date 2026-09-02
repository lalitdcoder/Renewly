//
//  OnboardingBellGraphic.swift
//  Renewly
//

import SwiftUI

struct OnboardingBellGraphic: View {
    @State private var ringAnimation = false
    
    var body: some View {
        ZStack {
            // Radiant glow
            Circle()
                .fill(Color.renewlyPrimaryLight.opacity(0.5))
                .frame(width: 180, height: 180)
                .blur(radius: 20)
            
            // Radiating rays
            ForEach(0..<8, id: \.self) { i in
                let angle = Double(i) * 45.0
                Capsule()
                    .fill(Color.renewlyPrimary.opacity(0.2))
                    .frame(width: 4, height: 12)
                    .offset(y: -72)
                    .rotationEffect(.degrees(angle))
            }
            
            // 3D Bell
            ZStack(alignment: .topTrailing) {
                // Bell Body
                ZStack {
                    // Main bell body
                    Image(systemName: "bell.fill")
                        .font(.system(size: 84))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [Color(hex: "7968FA"), Color(hex: "5640EA")],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .shadow(color: Color.renewlyPrimary.opacity(0.4), radius: 16, y: 8)
                }
                .rotationEffect(.degrees(ringAnimation ? -6 : 6))
                
                // Red badge with "1"
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [Color(hex: "FF5757"), Color(hex: "E02020")],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .frame(width: 28, height: 28)
                        .overlay(
                            Circle()
                                .stroke(Color.white, lineWidth: 2)
                        )
                        .shadow(color: Color.red.opacity(0.4), radius: 4, y: 2)
                    
                    Text("1")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(.white)
                }
                .offset(x: 6, y: -4)
            }
        }
        .frame(height: 180)
        .onAppear {
            withAnimation(.easeInOut(duration: 1.6).repeatForever(autoreverses: true)) {
                ringAnimation = true
            }
        }
    }
}
