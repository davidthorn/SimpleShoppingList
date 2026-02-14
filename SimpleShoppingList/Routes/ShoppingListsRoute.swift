//
//  ShoppingListsRoute.swift
//  SimpleShoppingList
//
//  Created by David Thorn on 14.02.2026.
//

import Foundation

public enum ShoppingListsRoute: Hashable {
    case createList
    case editList(listID: UUID)
    case detail(listID: UUID)
    case createItem(listID: UUID)
    case editItem(listID: UUID, itemID: UUID)
}
