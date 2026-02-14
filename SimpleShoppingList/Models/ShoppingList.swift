//
//  ShoppingList.swift
//  SimpleShoppingList
//
//  Created by David Thorn on 14.02.2026.
//

import Foundation

public struct ShoppingList: Codable, Identifiable, Hashable, Sendable {
    public let id: UUID
    public var name: String
    public var items: [ShoppingItem]
    public let createdAt: Date
    public var updatedAt: Date

    public init(
        id: UUID = UUID(),
        name: String,
        items: [ShoppingItem] = [],
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.items = items
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

public extension ShoppingList {
    var itemCount: Int {
        items.count
    }

    var collectedCount: Int {
        items.filter(\.isCollected).count
    }

    var totalPrice: Double {
        items.reduce(0) { partialResult, item in
            partialResult + item.price
        }
    }
}
