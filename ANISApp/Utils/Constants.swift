//
//  Constants.swift
//  ANISmock
//
//  Created by Salman on 08/02/1447 AH.
//

import SwiftUI

struct AppColors {
    // Primary Colors - Mascot-aligned light palette
    static let primaryBackground = Color(red: 1.0, green: 0.957, blue: 0.867) // #FFF4DD
    static let navyDarker = Color(red: 0.03, green: 0.07, blue: 0.16) // Retained for compatibility, avoid using
    static let secondaryBackground = Color.white.opacity(0.6)
    static let cardBackground = Color.white.opacity(0.9)
    
    // Accent Colors - From mascot palette
    static let accentGreen = Color(red: 0.541, green: 0.757, blue: 0.522) // #8AC185 - Success/Accept
    static let accentRed = Color(red: 0.95, green: 0.26, blue: 0.21) // #F44336 - Decline/Error
    static let accentBlue = Color(red: 0.13, green: 0.59, blue: 0.95) // #2196F3 - Primary action
    static let accentOrange = Color(red: 1.0, green: 0.60, blue: 0.0) // #FF9800 - Warning/Secondary
    
    // Text Colors
    static let primaryText = Color(red: 0.082, green: 0.173, blue: 0.267) // #152C44
    static let secondaryText = primaryText.opacity(0.7)
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
    static let dividerColor = primaryText.opacity(0.12) // For dividers
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

// MARK: - Reusable UI Helpers
import SwiftUI

struct PressableScaleStyle: ButtonStyle {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed && !reduceMotion ? 0.96 : 1.0)
            .animation(reduceMotion ? .none : .spring(response: 0.35, dampingFraction: 0.85), value: configuration.isPressed)
    }
}

struct AppearAnimation: ViewModifier {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var appeared = false
    let delay: Double
    
    func body(content: Content) -> some View {
        content
            .opacity(appeared ? 1 : 0)
            .offset(y: appeared || reduceMotion ? 0 : 8)
            .onAppear {
                if reduceMotion {
                    appeared = true
                } else {
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.9).delay(delay)) {
                        appeared = true
                    }
                }
            }
    }
}

extension View {
    func pressable() -> some View { self.buttonStyle(PressableScaleStyle()) }
    func animatedOnAppear(delay: Double = 0) -> some View { self.modifier(AppearAnimation(delay: delay)) }
}