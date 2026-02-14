//
//  ShoppingStore.swift
//  SimpleShoppingList
//
//  Created by David Thorn on 14.02.2026.
//

import Foundation

public actor ShoppingStore: ShoppingStoreProtocol {
    private var lists: [ShoppingList]
    private var continuations: [UUID: AsyncStream<[ShoppingList]>.Continuation]

    private let fileURL: URL
    private let fileManager: FileManager
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder

    public init(
        fileManager: FileManager = .default,
        fileName: String = "shopping-lists.json"
    ) {
        self.fileManager = fileManager
        self.encoder = JSONEncoder()
        let decoder = JSONDecoder()
        self.decoder = decoder
        self.continuations = [:]

        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
            ?? URL(fileURLWithPath: NSTemporaryDirectory())
        self.fileURL = documentsURL.appendingPathComponent(fileName)
        self.lists = Self.loadFromDisk(fileManager: fileManager, fileURL: self.fileURL, decoder: decoder)
    }

    public func listsStream() -> AsyncStream<[ShoppingList]> {
        let streamID = UUID()

        return AsyncStream { continuation in
            Task {
                addContinuation(continuation, streamID: streamID)
            }
            continuation.onTermination = { [weak self] _ in
                Task {
                    await self?.removeContinuation(streamID: streamID)
                }
            }
        }
    }

    public func fetchLists() async -> [ShoppingList] {
        sortedLists()
    }

    public func upsertList(_ list: ShoppingList) async {
        if let index = lists.firstIndex(where: { $0.id == list.id }) {
            lists[index] = list
        } else {
            lists.append(list)
        }

        persistAndBroadcast()
    }

    public func deleteList(id: UUID) async {
        lists.removeAll { $0.id == id }
        persistAndBroadcast()
    }

    public func upsertItem(_ item: ShoppingItem, inListID listID: UUID) async {
        guard let listIndex = lists.firstIndex(where: { $0.id == listID }) else {
            return
        }

        var list = lists[listIndex]
        if let itemIndex = list.items.firstIndex(where: { $0.id == item.id }) {
            list.items[itemIndex] = item
        } else {
            list.items.append(item)
        }
        list.updatedAt = Date()
        lists[listIndex] = list

        persistAndBroadcast()
    }

    public func deleteItem(id: UUID, fromListID listID: UUID) async {
        guard let listIndex = lists.firstIndex(where: { $0.id == listID }) else {
            return
        }

        var list = lists[listIndex]
        list.items.removeAll { $0.id == id }
        list.updatedAt = Date()
        lists[listIndex] = list

        persistAndBroadcast()
    }

    public func setItemCollected(_ isCollected: Bool, itemID: UUID, inListID listID: UUID) async {
        guard let listIndex = lists.firstIndex(where: { $0.id == listID }) else {
            return
        }

        var list = lists[listIndex]
        guard let itemIndex = list.items.firstIndex(where: { $0.id == itemID }) else {
            return
        }

        var item = list.items[itemIndex]
        item.isCollected = isCollected
        item.updatedAt = Date()
        list.items[itemIndex] = item
        list.updatedAt = Date()
        lists[listIndex] = list

        persistAndBroadcast()
    }

    private func sortedLists() -> [ShoppingList] {
        lists.sorted { $0.updatedAt > $1.updatedAt }
    }

    private func persistAndBroadcast() {
        persistToDisk()
        broadcast()
    }

    private func broadcast() {
        let snapshot = sortedLists()
        for continuation in continuations.values {
            continuation.yield(snapshot)
        }
    }

    private func addContinuation(_ continuation: AsyncStream<[ShoppingList]>.Continuation, streamID: UUID) {
        continuation.yield(sortedLists())
        continuations[streamID] = continuation
    }

    private func removeContinuation(streamID: UUID) {
        continuations.removeValue(forKey: streamID)
    }

    private static func loadFromDisk(fileManager: FileManager, fileURL: URL, decoder: JSONDecoder) -> [ShoppingList] {
        guard fileManager.fileExists(atPath: fileURL.path) else {
            return []
        }

        do {
            let data = try Data(contentsOf: fileURL)
            return try decoder.decode([ShoppingList].self, from: data)
        } catch {
            return []
        }
    }

    private func persistToDisk() {
        do {
            let data = try encoder.encode(lists)
            try data.write(to: fileURL, options: .atomic)
        } catch {
            return
        }
    }
}
