//
//  ShoppingStoreProtocol.swift
//  SimpleShoppingList
//
//  Created by David Thorn on 14.02.2026.
//

import Foundation

public protocol ShoppingStoreProtocol: Actor {
    func listsStream() -> AsyncStream<[ShoppingList]>
    func fetchLists() async -> [ShoppingList]
    func upsertList(_ list: ShoppingList) async
    func deleteList(id: UUID) async
    func upsertItem(_ item: ShoppingItem, inListID listID: UUID) async
    func deleteItem(id: UUID, fromListID listID: UUID) async
    func setItemCollected(_ isCollected: Bool, itemID: UUID, inListID listID: UUID) async
}
