//
//  ShoppingListsViewModel.swift
//  SimpleShoppingList
//
//  Created by David Thorn on 14.02.2026.
//

import Combine
import Foundation

@MainActor
public final class ShoppingListsViewModel: ObservableObject {
    @Published public private(set) var lists: [ShoppingList]

    private let shoppingStore: ShoppingStoreProtocol
    private var streamTask: Task<Void, Never>?

    public init(shoppingStore: ShoppingStoreProtocol) {
        self.shoppingStore = shoppingStore
        self.lists = []
        streamTask = Task {
            await observeLists()
        }
    }

    deinit {
        streamTask?.cancel()
    }

    public func deleteList(id: UUID) async {
        await shoppingStore.deleteList(id: id)
    }

    private func observeLists() async {
        let stream = await shoppingStore.listsStream()

        for await lists in stream {
            if Task.isCancelled {
                return
            }

            self.lists = lists
        }
    }
}
