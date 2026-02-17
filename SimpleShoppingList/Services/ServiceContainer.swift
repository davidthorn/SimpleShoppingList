//
//  ServiceContainer.swift
//  SimpleShoppingList
//
//  Created by David Thorn on 14.02.2026.
//

import Foundation
import SimpleFramework

/// Default dependency container for `SimpleShoppingList`.
public struct ServiceContainer: ServiceContainerProtocol {
    /// Shopping service dependency used by scenes and views.
    public let shoppingService: ShoppingServiceProtocol

    /// Creates a service container with configurable dependencies.
    public init(
        shoppingStore: ShoppingStoreProtocol = JSONEntityStore<ShoppingList>(
            fileName: "shopping-lists.json",
            sort: { lhs, rhs in
                lhs.updatedAt > rhs.updatedAt
            }
        )
    ) {
        self.shoppingService = ShoppingService(
            shoppingStore: shoppingStore,
            fileName: "shopping-lists.json"
        )
    }

    /// Seeds initial data only when persistence is currently empty.
    public func bootstrapStoreIfNeeded(with lists: [ShoppingList]) async {
        let existingLists = await shoppingService.fetchLists()
        guard existingLists.isEmpty else {
            return
        }

        for list in lists {
            await shoppingService.upsertList(list)
        }
    }
}
