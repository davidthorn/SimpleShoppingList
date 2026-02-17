//
//  ShoppingListEditorViewModel.swift
//  SimpleShoppingList
//
//  Created by David Thorn on 14.02.2026.
//

import Combine
import Foundation

@MainActor
public final class ShoppingListEditorViewModel: ObservableObject {
    @Published public var name: String

    public let listID: UUID
    public let isPersisted: Bool

    private let shoppingService: ShoppingServiceProtocol
    private var originalList: ShoppingList?
    private var streamTask: Task<Void, Never>?

    public init(shoppingService: ShoppingServiceProtocol, listID: UUID?) {
        self.shoppingService = shoppingService
        self.originalList = nil
        self.listID = listID ?? UUID()
        self.name = ""
        self.isPersisted = listID != nil

        if listID != nil {
            streamTask = Task {
                if Task.isCancelled {
                    return
                }
                await observeList()
            }
        }
    }

    deinit {
        streamTask?.cancel()
    }

    public var canSave: Bool {
        !trimmedName.isEmpty
    }

    public var hasChanges: Bool {
        trimmedName != originalTrimmedName
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
        name = originalList?.name ?? ""
    }

    public func save() async {
        guard canSave else {
            return
        }

        let now = Date()
        var list = originalList ?? ShoppingList(id: listID, name: trimmedName, items: [], createdAt: now, updatedAt: now)
        list.name = trimmedName
        list.updatedAt = now

        await shoppingService.upsertList(list)
    }

    public func delete() async {
        await shoppingService.deleteList(id: listID)
    }

    private func observeList() async {
        let stream = await shoppingService.listsStream()
        for await lists in stream {
            if Task.isCancelled {
                return
            }

            guard let matchingList = lists.first(where: { $0.id == listID }) else {
                continue
            }

            if originalList == nil {
                originalList = matchingList
                name = matchingList.name
            } else {
                originalList = matchingList
            }
        }
    }

    private var trimmedName: String {
        name.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private var originalTrimmedName: String {
        originalList?.name.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
    }
}
