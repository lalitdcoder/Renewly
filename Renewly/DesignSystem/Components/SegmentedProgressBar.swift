//
//  SegmentedProgressBar.swift
//  Renewly
//

import SwiftUI

struct SegmentedProgressBar: View {
    let currentStep: Int
    let totalSteps: Int
    
    var body: some View {
        HStack(spacing: 6) {
            ForEach(1...totalSteps, id: \.self) { step in
                Capsule()
                    .fill(step <= currentStep ? Color.renewlyPrimary : Color(hex: "E8E8ED"))
                    .frame(height: 4)
                    .animation(.spring(response: 0.35, dampingFraction: 0.8), value: currentStep)
            }
        }
        .padding(.horizontal, 24)
    }
}
