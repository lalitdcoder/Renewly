//
//  ConfettiCheckmarkView.swift
//  Renewly
//

import SwiftUI

struct ConfettiCheckmarkView: View {
    @State private var animateParticles = false
    
    private let particleColors: [Color] = [
        Color(hex: "FF6B6B"),
        Color(hex: "4D96FF"),
        Color(hex: "6BCB77"),
        Color(hex: "FFD93D"),
        Color(hex: "9D4EDD"),
        Color(hex: "FF9F45")
    ]
    
    var body: some View {
        ZStack {
            // Floating confetti particles
            ForEach(0..<14, id: \.self) { i in
                let angle = Double(i) * (360.0 / 14.0)
                let radius: CGFloat = animateParticles ? (i % 2 == 0 ? 64 : 52) : 25
                let color = particleColors[i % particleColors.count]
                let isCapsule = i % 3 == 0
                
                Group {
                    if isCapsule {
                        Capsule()
                            .fill(color)
                            .frame(width: 8, height: 4)
                            .rotationEffect(.degrees(angle * 2))
                    } else {
                        Circle()
                            .fill(color)
                            .frame(width: 6, height: 6)
                    }
                }
                .offset(
                    x: cos(angle * .pi / 180.0) * radius,
                    y: sin(angle * .pi / 180.0) * radius
                )
                .opacity(animateParticles ? 1.0 : 0.0)
                .scaleEffect(animateParticles ? 1.0 : 0.3)
            }
            
            // Central checkmark circle
            ZStack {
                Circle()
                    .fill(Color.renewlyPrimary)
                    .frame(width: 72, height: 72)
                    .shadow(color: Color.renewlyPrimary.opacity(0.3), radius: 12, y: 6)
                
                Image(systemName: "checkmark")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
            }
            .scaleEffect(animateParticles ? 1.0 : 0.6)
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.65)) {
                animateParticles = true
            }
        }
    }
}
