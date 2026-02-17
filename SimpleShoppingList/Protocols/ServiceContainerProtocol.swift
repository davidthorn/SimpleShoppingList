//
//  ServiceContainerProtocol.swift
//  SimpleShoppingList
//
//  Created by David Thorn on 14.02.2026.
//

import Foundation

/// Dependency container contract for app-level services.
public protocol ServiceContainerProtocol: Sendable {
    /// Shopping domain service used across shopping list flows.
    var shoppingService: ShoppingServiceProtocol { get }
    /// Seeds initial data when no persisted lists exist.
    func bootstrapStoreIfNeeded(with lists: [ShoppingList]) async
}
