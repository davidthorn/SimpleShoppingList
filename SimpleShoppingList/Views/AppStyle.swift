//
//  AppStyle.swift
//  SimpleShoppingList
//
//  Created by David Thorn on 14.02.2026.
//

import SwiftUI

public enum AppStyle {
    public static let accent = Color(red: 0.78, green: 0.36, blue: 0.52)
    public static let success = Color(red: 0.24, green: 0.63, blue: 0.44)
    public static let textSecondary = Color(red: 0.45, green: 0.45, blue: 0.52)

    public static var background: LinearGradient {
        LinearGradient(
            colors: [
                Color(red: 0.99, green: 0.97, blue: 0.98),
                Color(red: 0.96, green: 0.96, blue: 0.99)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    public static var cardFill: Color {
        Color.white.opacity(0.9)
    }

    public static var cardBorder: Color {
        Color.white
    }

    public static var formBackground: Color {
        Color(red: 0.93, green: 0.91, blue: 0.95)
    }

    public static var formRowBackground: Color {
        Color(red: 1.0, green: 0.99, blue: 1.0)
    }
}
