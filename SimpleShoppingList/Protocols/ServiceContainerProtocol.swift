//
//  ServiceContainerProtocol.swift
//  SimpleShoppingList
//
//  Created by David Thorn on 14.02.2026.
//

import Foundation

public protocol ServiceContainerProtocol {
    var shoppingStore: ShoppingStoreProtocol { get }
    func bootstrapStoreIfNeeded(with lists: [ShoppingList]) async
}
