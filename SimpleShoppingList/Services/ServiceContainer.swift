//
//  ServiceContainer.swift
//  SimpleShoppingList
//
//  Created by David Thorn on 14.02.2026.
//

import Foundation

public struct ServiceContainer: ServiceContainerProtocol {
    public let shoppingStore: ShoppingStoreProtocol

    public init(shoppingStore: ShoppingStoreProtocol = ShoppingStore()) {
        self.shoppingStore = shoppingStore
    }

    public func bootstrapStoreIfNeeded(with lists: [ShoppingList]) async {
        let existingLists = await shoppingStore.fetchLists()
        guard existingLists.isEmpty else {
            return
        }

        for list in lists {
            await shoppingStore.upsertList(list)
        }
    }
}
