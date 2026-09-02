//
//  Typography.swift
//  Renewly
//

import SwiftUI

extension Font {
    // Custom font tokens matching the mockup
    static let renewlyLargeTitle = Font.system(size: 28, weight: .bold, design: .rounded)
    static let renewlyTitle1 = Font.system(size: 24, weight: .bold, design: .default)
    static let renewlyTitle2 = Font.system(size: 20, weight: .bold, design: .default)
    static let renewlyTitle3 = Font.system(size: 17, weight: .semibold, design: .default)
    
    static let renewlyHeadline = Font.system(size: 16, weight: .semibold, design: .default)
    static let renewlyBody = Font.system(size: 15, weight: .regular, design: .default)
    static let renewlyBodyMedium = Font.system(size: 15, weight: .medium, design: .default)
    
    static let renewlySubheadline = Font.system(size: 14, weight: .medium, design: .default)
    static let renewlyFootnote = Font.system(size: 13, weight: .regular, design: .default)
    static let renewlyFootnoteMedium = Font.system(size: 13, weight: .medium, design: .default)
    static let renewlyFootnoteBold = Font.system(size: 13, weight: .bold, design: .default)
    static let renewlyCaption = Font.system(size: 11, weight: .medium, design: .default)
    
    // Numeric styles
    static let renewlyAmountHero = Font.system(size: 38, weight: .bold, design: .rounded)
    static let renewlyAmountLarge = Font.system(size: 28, weight: .bold, design: .rounded)
}
