//
//  SignUpView.swift
//  ANISmock
//
//  Created by Salman on 08/02/1447 AH.
//

import SwiftUI

struct SignUpView: View {
    @Binding var currentStep: Int
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var email = ""
    @State private var isLoading = false
    
    var body: some View {
        VStack(spacing: AppSpacing.xxl) {
            Spacer()
            
            // App branding
            VStack(spacing: AppSpacing.lg) {
                Image("Mascot")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                // App logo text only
                Text("ANIS")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundColor(Color(red: 0.082, green: 0.173, blue: 0.267)) // #152C44
            }
            
            VStack(spacing: AppSpacing.lg) {
                Text("Create an account")
                    .font(AppFonts.title2)
                    .foregroundColor(Color(red: 0.082, green: 0.173, blue: 0.267))
                
                Text("Enter your email to sign up for this app")
                    .font(AppFonts.body)
                    .foregroundColor(Color(red: 0.082, green: 0.173, blue: 0.267).opacity(0.75))
                    .multilineTextAlignment(.center)
            }
            
            // Email input
            VStack(spacing: AppSpacing.md) {
                TextField("Email", text: $email)
                    .textFieldStyle(CustomTextFieldStyle())
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                
                // Or separator
                HStack {
                    Rectangle()
                        .fill(AppColors.mutedText.opacity(0.3))
                        .frame(height: 1)
                    
                    Text("or")
                        .font(AppFonts.footnote)
                        .foregroundColor(Color(red: 0.082, green: 0.173, blue: 0.267))
                        .padding(.horizontal, AppSpacing.md)
                    
                    Rectangle()
                        .fill(AppColors.mutedText.opacity(0.3))
                        .frame(height: 1)
                }
                .padding(.vertical, AppSpacing.md)
                
                // Apple Sign In button
                Button(action: {
                    isLoading = true
                    Task {
                        await authViewModel.signInWithApple()
                        isLoading = false
                    }
                }) {
                    HStack(spacing: AppSpacing.md) {
                        Image(systemName: "applelogo")
                            .font(.title2)
                        
                        Text("Continue with Apple")
                            .font(AppFonts.headline)
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(
                        RoundedRectangle(cornerRadius: AppCornerRadius.medium)
                            .fill(Color.black)
                    )
                    .shadow(color: .black.opacity(0.1), radius: 3, x: 0, y: 1)
                }
                .pressable()
                .disabled(isLoading)
            }
            .padding(.horizontal, AppSpacing.xl)
            
            Spacer()
            
            // Terms and privacy
            Text("By clicking continue, you agree to our Terms of Service and Privacy Policy")
                .font(AppFonts.caption)
                .foregroundColor(AppColors.mutedText)
                .multilineTextAlignment(.center)
                .padding(.horizontal, AppSpacing.xl)
                .padding(.bottom, AppSpacing.lg)
        }
        .overlay(
            Group {
                if isLoading {
                    ZStack {
                        Color.black.opacity(0.3)
                            .ignoresSafeArea()
                        
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: AppColors.primaryText))
                            .scaleEffect(1.5)
                    }
                }
            }
        )
        .animation(.easeInOut(duration: 0.2), value: isLoading)
    }
}

struct CustomTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(AppSpacing.md)
            .background(
                RoundedRectangle(cornerRadius: AppCornerRadius.medium)
                    .fill(AppColors.secondaryBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: AppCornerRadius.medium)
                            .stroke(AppColors.mutedText.opacity(0.3), lineWidth: 1)
                    )
            )
            .foregroundColor(AppColors.primaryText)
    }
}

#Preview {
    SignUpView(currentStep: .constant(2))
        .environmentObject(AuthViewModel())
} 