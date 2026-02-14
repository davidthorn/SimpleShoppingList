//
//  ShoppingListRowComponent.swift
//  SimpleShoppingList
//
//  Created by David Thorn on 14.02.2026.
//

import SwiftUI

public struct ShoppingListRowComponent: View {
    public let list: ShoppingList

    public init(list: ShoppingList) {
        self.list = list
    }

    public var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "bag.circle.fill")
                .font(.title3)
                .foregroundStyle(AppStyle.accent)

            VStack(alignment: .leading, spacing: 4) {
                Text(list.name)
                    .font(.headline)
                Text("\(list.collectedCount)/\(list.itemCount) collected")
                    .font(.subheadline)
                    .foregroundStyle(AppStyle.textSecondary)
            }
        }
        .padding(.vertical, 8)
    }
}

#if DEBUG
#Preview {
    ShoppingListRowComponent(
        list: ShoppingList(
            name: "Weekly Groceries",
            items: [
                ShoppingItem(listID: UUID(), name: "Milk", price: 2.50, isCollected: true)
            ]
        )
    )
    .padding()
}
#endif
