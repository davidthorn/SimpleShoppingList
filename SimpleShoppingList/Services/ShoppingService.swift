//
//  ShoppingService.swift
//  SimpleShoppingList
//
//  Created by David Thorn on 17.02.2026.
//

import Foundation

/// Default shopping domain service backed by `ShoppingStoreProtocol`.
public actor ShoppingService: ShoppingServiceProtocol {
    private let shoppingStore: ShoppingStoreProtocol
    private let fileName: String
    private let iso8601Decoder: JSONDecoder
    private let iso8601Encoder: JSONEncoder
    private let legacyDecoder: JSONDecoder
    private var didPrepareStore: Bool

    /// Creates a shopping service with a store dependency.
    public init(
        shoppingStore: ShoppingStoreProtocol,
        fileName: String = "shopping-lists.json"
    ) {
        self.shoppingStore = shoppingStore
        self.fileName = fileName
        let iso8601Decoder = JSONDecoder()
        iso8601Decoder.dateDecodingStrategy = .iso8601
        self.iso8601Decoder = iso8601Decoder

        let iso8601Encoder = JSONEncoder()
        iso8601Encoder.dateEncodingStrategy = .iso8601
        self.iso8601Encoder = iso8601Encoder

        self.legacyDecoder = JSONDecoder()
        self.didPrepareStore = false
    }

    /// Streams full shopping list snapshots whenever data changes.
    public func listsStream() async -> AsyncStream<[ShoppingList]> {
        await prepareStoreIfNeeded()
        return await shoppingStore.listsStream()
    }

    /// Fetches the latest persisted shopping lists.
    public func fetchLists() async -> [ShoppingList] {
        await prepareStoreIfNeeded()
        return await shoppingStore.fetchLists()
    }

    /// Creates or updates a shopping list.
    public func upsertList(_ list: ShoppingList) async {
        await prepareStoreIfNeeded()
        await shoppingStore.upsertList(list)
    }

    /// Deletes a shopping list by identifier.
    public func deleteList(id: UUID) async {
        await prepareStoreIfNeeded()
        await shoppingStore.deleteList(id: id)
    }

    /// Creates or updates an item in the provided shopping list.
    public func upsertItem(_ item: ShoppingItem, inListID listID: UUID) async {
        guard let list = await fetchLists().first(where: { $0.id == listID }) else {
            return
        }

        var updatedList = list
        if let itemIndex = updatedList.items.firstIndex(where: { $0.id == item.id }) {
            updatedList.items[itemIndex] = item
        } else {
            updatedList.items.append(item)
        }
        updatedList.updatedAt = Date()
        await shoppingStore.upsertList(updatedList)
    }

    /// Deletes an item from the provided shopping list.
    public func deleteItem(id: UUID, fromListID listID: UUID) async {
        guard let list = await fetchLists().first(where: { $0.id == listID }) else {
            return
        }

        var updatedList = list
        updatedList.items.removeAll { $0.id == id }
        updatedList.updatedAt = Date()
        await shoppingStore.upsertList(updatedList)
    }

    /// Updates collected state for an item in the provided shopping list.
    public func setItemCollected(_ isCollected: Bool, itemID: UUID, inListID listID: UUID) async {
        guard let list = await fetchLists().first(where: { $0.id == listID }) else {
            return
        }

        var updatedList = list
        guard let itemIndex = updatedList.items.firstIndex(where: { $0.id == itemID }) else {
            return
        }

        var updatedItem = updatedList.items[itemIndex]
        updatedItem.isCollected = isCollected
        updatedItem.updatedAt = Date()
        updatedList.items[itemIndex] = updatedItem
        updatedList.updatedAt = Date()
        await shoppingStore.upsertList(updatedList)
    }

    private func prepareStoreIfNeeded() async {
        guard !didPrepareStore else {
            return
        }
        didPrepareStore = true

        if Task.isCancelled {
            return
        }

        let fileManager = FileManager.default
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
        guard let documentsDirectory else {
            return
        }

        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        guard fileManager.fileExists(atPath: fileURL.path) else {
            return
        }

        guard let data = try? Data(contentsOf: fileURL) else {
            return
        }

        if (try? iso8601Decoder.decode([ShoppingList].self, from: data)) != nil {
            return
        }

        if let legacyLists = try? legacyDecoder.decode([ShoppingList].self, from: data) {
            guard let migratedData = try? iso8601Encoder.encode(legacyLists) else {
                return
            }
            try? migratedData.write(to: fileURL, options: .atomic)
            return
        }

        guard let emptyData = try? iso8601Encoder.encode([ShoppingList]()) else {
            return
        }
        try? emptyData.write(to: fileURL, options: .atomic)
    }
}
