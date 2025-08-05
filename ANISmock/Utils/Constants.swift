//
//  Constants.swift
//  ANISmock
//
//  Created by Salman on 08/02/1447 AH.
//

import SwiftUI

struct AppColors {
    // Primary Colors - Matching your design references
    static let primaryBackground = Color(red: 0.06, green: 0.11, blue: 0.24) // Deep blue from your mockups
    static let secondaryBackground = Color(red: 0.12, green: 0.18, blue: 0.32) // Lighter blue-grey
    static let cardBackground = Color(red: 0.15, green: 0.20, blue: 0.35) // Card backgrounds
    
    // Accent Colors - From your design palette
    static let accentGreen = Color(red: 0.30, green: 0.69, blue: 0.31) // #4CAF50 - Success/Accept
    static let accentRed = Color(red: 0.95, green: 0.26, blue: 0.21) // #F44336 - Decline/Error
    static let accentBlue = Color(red: 0.13, green: 0.59, blue: 0.95) // #2196F3 - Primary action
    static let accentOrange = Color(red: 1.0, green: 0.60, blue: 0.0) // #FF9800 - Warning/Secondary
    
    // Text Colors
    static let primaryText = Color.white
    static let secondaryText = Color(red: 0.78, green: 0.78, blue: 0.78) // Light grey
    static let mutedText = Color(red: 0.54, green: 0.54, blue: 0.54) // Muted grey
    static let placeholderText = Color(red: 0.42, green: 0.42, blue: 0.42) // Placeholder
    
    // Sport Colors - Vibrant and distinct
    static let padelColor = Color(red: 0.94, green: 0.20, blue: 0.20) // Bright red for padel
    static let footballColor = Color(red: 0.13, green: 0.59, blue: 0.95) // Blue for football
    static let tennisColor = Color(red: 1.0, green: 0.76, blue: 0.03) // Yellow for tennis
    static let volleyballColor = Color(red: 1.0, green: 0.60, blue: 0.0) // Orange for volleyball
    static let basketballColor = Color(red: 0.91, green: 0.12, blue: 0.39) // Pink for basketball
    
    // Special UI Colors
    static let glassMaterial = Color.white.opacity(0.1) // For frosted glass effects
    static let dividerColor = Color.white.opacity(0.12) // For dividers
    static let shadowColor = Color.black.opacity(0.25) // For shadows
}

struct AppFonts {
    static let largeTitle = Font.system(size: 34, weight: .bold)
    static let title = Font.system(size: 28, weight: .bold)
    static let title2 = Font.system(size: 22, weight: .bold)
    static let title3 = Font.system(size: 20, weight: .semibold)
    static let headline = Font.system(size: 17, weight: .semibold)
    static let body = Font.system(size: 17, weight: .regular)
    static let callout = Font.system(size: 16, weight: .regular)
    static let subheadline = Font.system(size: 15, weight: .regular)
    static let footnote = Font.system(size: 13, weight: .regular)
    static let caption = Font.system(size: 12, weight: .regular)
}

struct AppSpacing {
    static let xs: CGFloat = 4
    static let sm: CGFloat = 8
    static let md: CGFloat = 16
    static let lg: CGFloat = 24
    static let xl: CGFloat = 32
    static let xxl: CGFloat = 48
}

struct AppCornerRadius {
    static let small: CGFloat = 8
    static let medium: CGFloat = 12
    static let large: CGFloat = 16
    static let xl: CGFloat = 24
}

struct AppBlur {
    static let light = UIBlurEffect(style: .systemUltraThinMaterial)
    static let medium = UIBlurEffect(style: .systemThinMaterial)
    static let heavy = UIBlurEffect(style: .systemMaterial)
} 