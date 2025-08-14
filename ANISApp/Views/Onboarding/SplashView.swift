//
//  SplashView.swift
//  ANISmock
//
//  Created by Salman on 08/02/1447 AH.
//

import SwiftUI

struct SplashView: View {
    @State private var logoScale: CGFloat = 0.5
    @State private var logoOpacity: Double = 0
    @State private var textOpacity: Double = 0
    
    var body: some View {
        ZStack {
            // Background - User's preferred color
            Color(red: 1.0, green: 0.957, blue: 0.867) // #FFF4DD
                .ignoresSafeArea()
            
            VStack(spacing: AppSpacing.xl) {
                // App Logo - Mascot + Text
                VStack(spacing: AppSpacing.md) {
                    Image("Mascot")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 280, height: 280)
                        .shadow(color: .black.opacity(0.1), radius: 6, x: 0, y: 3)
                        .scaleEffect(logoScale)
                        .opacity(logoOpacity)

                    // App name
                    Text("ANIS")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundColor(Color(red: 0.082, green: 0.173, blue: 0.267)) // #152C44
                        .scaleEffect(logoScale)
                        .opacity(logoOpacity)
                }
                
                // Tagline
                Text("Connect through sports activities")
                    .font(AppFonts.title3)
                    .foregroundColor(Color(red: 0.082, green: 0.173, blue: 0.267).opacity(0.7))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, AppSpacing.xl)
                    .opacity(textOpacity)
                
                // Subtitle
                Text("Find, create, and join sports activities in your area")
                    .font(AppFonts.body)
                    .foregroundColor(Color(red: 0.082, green: 0.173, blue: 0.267).opacity(0.6))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, AppSpacing.xl)
                    .opacity(textOpacity)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.8)) {
                logoScale = 1.0
                logoOpacity = 1.0
            }
            
            withAnimation(.easeOut(duration: 0.8).delay(0.3)) {
                textOpacity = 1.0
            }
        }
    }
}



#Preview {
    SplashView()
} 