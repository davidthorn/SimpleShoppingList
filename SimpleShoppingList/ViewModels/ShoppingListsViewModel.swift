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

    private let shoppingService: ShoppingServiceProtocol
    private var streamTask: Task<Void, Never>?

    public init(shoppingService: ShoppingServiceProtocol) {
        self.shoppingService = shoppingService
        self.lists = []
        streamTask = Task {
            if Task.isCancelled {
                return
            }
            await observeLists()
        }
    }

    deinit {
        streamTask?.cancel()
    }

    public func deleteList(id: UUID) async {
        await shoppingService.deleteList(id: id)
    }

    private func observeLists() async {
        let stream = await shoppingService.listsStream()

        for await lists in stream {
            if Task.isCancelled {
                return
            }

            self.lists = lists
        }
    }
}
