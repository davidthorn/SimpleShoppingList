//
//  DashboardViewModel.swift
//  SimpleShoppingList
//
//  Created by David Thorn on 14.02.2026.
//

import Combine
import Foundation

@MainActor
public final class DashboardViewModel: ObservableObject {
    @Published public private(set) var summary: DashboardSummary

    private let shoppingStore: ShoppingStoreProtocol
    private var streamTask: Task<Void, Never>?

    public init(shoppingStore: ShoppingStoreProtocol) {
        self.shoppingStore = shoppingStore
        self.summary = .empty
        streamTask = Task {
            await observeLists()
        }
    }

    deinit {
        streamTask?.cancel()
    }

    private func observeLists() async {
        let stream = await shoppingStore.listsStream()

        for await lists in stream {
            if Task.isCancelled {
                return
            }

            summary = Self.makeSummary(from: lists)
        }
    }

    private static func makeSummary(from lists: [ShoppingList]) -> DashboardSummary {
        let totalLists = lists.count
        let totalItems = lists.reduce(0) { $0 + $1.itemCount }
        let totalCollectedItems = lists.reduce(0) { $0 + $1.collectedCount }
        let latestList = lists.first

        return DashboardSummary(
            totalLists: totalLists,
            totalItems: totalItems,
            totalCollectedItems: totalCollectedItems,
            latestListName: latestList?.name ?? DashboardSummary.empty.latestListName,
            latestListItemCount: latestList?.itemCount ?? 0,
            latestListCollectedCount: latestList?.collectedCount ?? 0
        )
    }
}
