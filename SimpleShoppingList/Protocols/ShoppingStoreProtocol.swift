//
//  ShoppingStoreProtocol.swift
//  SimpleShoppingList
//
//  Created by David Thorn on 14.02.2026.
//

import Foundation

/// Contract for shopping list and item persistence operations.
public protocol ShoppingStoreProtocol: Actor {
    /// Streams full shopping list snapshots whenever data changes.
    func listsStream() -> AsyncStream<[ShoppingList]>
    /// Fetches the latest persisted shopping lists.
    func fetchLists() async -> [ShoppingList]
    /// Creates or updates a shopping list.
    func upsertList(_ list: ShoppingList) async
    /// Deletes a shopping list by identifier.
    func deleteList(id: UUID) async
}
