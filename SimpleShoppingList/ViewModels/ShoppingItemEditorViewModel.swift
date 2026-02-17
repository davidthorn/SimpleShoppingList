//
//  ShoppingItemEditorViewModel.swift
//  SimpleShoppingList
//
//  Created by David Thorn on 14.02.2026.
//

import Combine
import Foundation

@MainActor
public final class ShoppingItemEditorViewModel: ObservableObject {
    @Published public var name: String
    @Published public var priceText: String

    public let listID: UUID
    public let itemID: UUID
    public let isPersisted: Bool

    private let shoppingService: ShoppingServiceProtocol
    private var originalItem: ShoppingItem?
    private var streamTask: Task<Void, Never>?

    public init(shoppingService: ShoppingServiceProtocol, listID: UUID, itemID: UUID?) {
        self.shoppingService = shoppingService
        self.listID = listID
        self.originalItem = nil
        self.itemID = itemID ?? UUID()
        self.name = ""
        self.priceText = ""
        self.isPersisted = itemID != nil

        if itemID != nil {
            streamTask = Task {
                if Task.isCancelled {
                    return
                }
                await observeItem()
            }
        }
    }

    deinit {
        streamTask?.cancel()
    }

    public var hasValidPrice: Bool {
        parsedPrice != nil
    }

    public var canSave: Bool {
        !trimmedName.isEmpty && hasValidPrice
    }

    public var hasChanges: Bool {
        let originalName = originalItem?.name.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let originalPrice = originalItem?.price
        return trimmedName != originalName || parsedPrice != originalPrice
    }

    public var shouldShowSaveButton: Bool {
        hasChanges && canSave
    }

    public var shouldShowResetButton: Bool {
        isPersisted && hasChanges
    }

    public var shouldShowDeleteButton: Bool {
        isPersisted
    }

    public func resetChanges() {
        name = originalItem?.name ?? ""
        priceText = originalItem.map { String(format: "%.2f", $0.price) } ?? ""
    }

    public func save() async {
        guard let price = parsedPrice, canSave else {
            return
        }

        let now = Date()
        let item = ShoppingItem(
            id: itemID,
            listID: listID,
            name: trimmedName,
            price: price,
            isCollected: originalItem?.isCollected ?? false,
            createdAt: originalItem?.createdAt ?? now,
            updatedAt: now
        )

        await shoppingService.upsertItem(item, inListID: listID)
    }

    public func delete() async {
        await shoppingService.deleteItem(id: itemID, fromListID: listID)
    }

    private func observeItem() async {
        let stream = await shoppingService.listsStream()
        for await lists in stream {
            if Task.isCancelled {
                return
            }

            guard
                let list = lists.first(where: { $0.id == listID }),
                let matchingItem = list.items.first(where: { $0.id == itemID })
            else {
                continue
            }

            if originalItem == nil {
                originalItem = matchingItem
                name = matchingItem.name
                priceText = String(format: "%.2f", matchingItem.price)
            } else {
                originalItem = matchingItem
            }
        }
    }

    private var trimmedName: String {
        name.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private var parsedPrice: Double? {
        let cleanText = priceText.trimmingCharacters(in: .whitespacesAndNewlines)
        return Double(cleanText)
    }
}
