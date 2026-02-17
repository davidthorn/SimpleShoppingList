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
    private let shoppingService: ShoppingServiceProtocol
    private var streamTask: Task<Void, Never>?

    public init(shoppingService: ShoppingServiceProtocol, listID: UUID) {
        self.shoppingService = shoppingService
        self.listID = listID
        self.list = nil
        streamTask = Task {
            if Task.isCancelled {
                return
            }
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
        await shoppingService.setItemCollected(isCollected, itemID: item.id, inListID: listID)
    }

    private func observeList() async {
        let stream = await shoppingService.listsStream()

        for await lists in stream {
            if Task.isCancelled {
                return
            }

            list = lists.first(where: { $0.id == listID })
        }
    }
}
