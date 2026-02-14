//
//  ShoppingListDetailViewModel.swift
//  SimpleShoppingList
//
//  Created by David Thorn on 14.02.2026.
//

import Combine
import Foundation

@MainActor
public final class ShoppingListDetailViewModel: ObservableObject {
    @Published public private(set) var list: ShoppingList?

    private let listID: UUID
    private let shoppingStore: ShoppingStoreProtocol
    private var streamTask: Task<Void, Never>?

    public init(shoppingStore: ShoppingStoreProtocol, listID: UUID) {
        self.shoppingStore = shoppingStore
        self.listID = listID
        self.list = nil
        streamTask = Task {
            await observeList()
        }
    }

    deinit {
        streamTask?.cancel()
    }

    public var title: String {
        list?.name ?? "Shopping List"
    }

    public var items: [ShoppingItem] {
        list?.items.sorted(by: { $0.createdAt < $1.createdAt }) ?? []
    }

    public func setCollected(_ isCollected: Bool, for item: ShoppingItem) async {
        await shoppingStore.setItemCollected(isCollected, itemID: item.id, inListID: listID)
    }

    private func observeList() async {
        let stream = await shoppingStore.listsStream()

        for await lists in stream {
            if Task.isCancelled {
                return
            }

            list = lists.first(where: { $0.id == listID })
        }
    }
}
