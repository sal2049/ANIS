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
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: [
                    AppColors.primaryBackground,
                    AppColors.secondaryBackground
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: AppSpacing.xl) {
                // Anis Owl Logo
                VStack(spacing: AppSpacing.md) {
                    // Owl character
                    ZStack {
                        Circle()
                            .fill(AppColors.cardBackground)
                            .frame(width: 120, height: 120)
                            .shadow(color: AppColors.shadowColor, radius: 15, x: 0, y: 8)
                        
                        // Owl face
                        VStack(spacing: 8) {
                            // Eyes
                            HStack(spacing: 20) {
                                Circle()
                                    .fill(AppColors.primaryText)
                                    .frame(width: 20, height: 20)
                                Circle()
                                    .fill(AppColors.primaryText)
                                    .frame(width: 20, height: 20)
                            }
                            
                            // Beak
                            Triangle()
                                .fill(AppColors.mutedText)
                                .frame(width: 12, height: 8)
                        }
                    }
                    .scaleEffect(logoScale)
                    .opacity(logoOpacity)
                    
                    // App name
                    Text("Anis")
                        .font(AppFonts.largeTitle)
                        .foregroundColor(AppColors.primaryText)
                        .opacity(textOpacity)
                }
                
                // Tagline
                Text("من البادل للجرى... كل الأنشطة اللى تهمك بمكان واحد")
                    .font(AppFonts.body)
                    .foregroundColor(AppColors.secondaryText)
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

// Custom triangle shape for owl beak
struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

#Preview {
    SplashView()
} 