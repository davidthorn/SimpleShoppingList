//
//  ShoppingServiceProtocol.swift
//  SimpleShoppingList
//
//  Created by David Thorn on 17.02.2026.
//

import Foundation

/// Contract for shopping list and shopping item domain operations.
public protocol ShoppingServiceProtocol: Sendable {
    /// Streams full shopping list snapshots whenever data changes.
    func listsStream() async -> AsyncStream<[ShoppingList]>
    /// Fetches the latest persisted shopping lists.
    func fetchLists() async -> [ShoppingList]
    /// Creates or updates a shopping list.
    func upsertList(_ list: ShoppingList) async
    /// Deletes a shopping list by identifier.
    func deleteList(id: UUID) async
    /// Creates or updates an item in the provided shopping list.
    func upsertItem(_ item: ShoppingItem, inListID listID: UUID) async
    /// Deletes an item from the provided shopping list.
    func deleteItem(id: UUID, fromListID listID: UUID) async
    /// Updates collected state for an item in the provided shopping list.
    func setItemCollected(_ isCollected: Bool, itemID: UUID, inListID listID: UUID) async
}
