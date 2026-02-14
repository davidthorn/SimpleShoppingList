//
//  CardSurfaceModifier.swift
//  SimpleShoppingList
//
//  Created by David Thorn on 14.02.2026.
//

import SwiftUI

public struct CardSurfaceModifier: ViewModifier {
    public init() {}

    public func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(AppStyle.cardFill)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .stroke(AppStyle.cardBorder, lineWidth: 1)
                    )
                    .shadow(color: .black.opacity(0.06), radius: 10, y: 5)
            )
    }
}

public extension View {
    func cardSurface() -> some View {
        modifier(CardSurfaceModifier())
    }
}
