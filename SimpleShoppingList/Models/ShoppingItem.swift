//
//  ShoppingItem.swift
//  SimpleShoppingList
//
//  Created by David Thorn on 14.02.2026.
//

import Foundation

public nonisolated struct ShoppingItem: Codable, Identifiable, Hashable, Sendable {
    public let id: UUID
    public let listID: UUID
    public var name: String
    public var price: Double
    public var isCollected: Bool
    public let createdAt: Date
    public var updatedAt: Date

    public init(
        id: UUID = UUID(),
        listID: UUID,
        name: String,
        price: Double,
        isCollected: Bool = false,
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.listID = listID
        self.name = name
        self.price = price
        self.isCollected = isCollected
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
