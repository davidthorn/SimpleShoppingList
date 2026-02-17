//
//  ShoppingStore.swift
//  SimpleShoppingList
//
//  Created by David Thorn on 14.02.2026.
//

import Foundation
import SimpleFramework

extension JSONEntityStore: ShoppingStoreProtocol where Entity == ShoppingList {
    public func listsStream() -> AsyncStream<[ShoppingList]> {
        let streamPair = AsyncStream<[ShoppingList]>.makeStream()
        let observationTask = Task {
            if Task.isCancelled {
                return
            }

            do {
                let stream = try await observeEntities()
                for await snapshot in stream {
                    if Task.isCancelled {
                        return
                    }
                    streamPair.continuation.yield(snapshot)
                }
            } catch {
                streamPair.continuation.yield([])
            }
        }

        streamPair.continuation.onTermination = { _ in
            observationTask.cancel()
        }
        return streamPair.stream
    }

    public func fetchLists() async -> [ShoppingList] {
        (try? await fetchEntities()) ?? []
    }

    public func upsertList(_ list: ShoppingList) async {
        try? await upsertEntity(list)
    }

    public func deleteList(id: UUID) async {
        try? await deleteEntity(id: id)
    }
}
