//
//  DashboardSummary.swift
//  SimpleShoppingList
//
//  Created by David Thorn on 14.02.2026.
//

import Foundation

public struct DashboardSummary: Sendable {
    public let totalLists: Int
    public let totalItems: Int
    public let totalCollectedItems: Int
    public let latestListName: String
    public let latestListItemCount: Int
    public let latestListCollectedCount: Int

    public init(
        totalLists: Int,
        totalItems: Int,
        totalCollectedItems: Int,
        latestListName: String,
        latestListItemCount: Int,
        latestListCollectedCount: Int
    ) {
        self.totalLists = totalLists
        self.totalItems = totalItems
        self.totalCollectedItems = totalCollectedItems
        self.latestListName = latestListName
        self.latestListItemCount = latestListItemCount
        self.latestListCollectedCount = latestListCollectedCount
    }

    public static let empty = DashboardSummary(
        totalLists: 0,
        totalItems: 0,
        totalCollectedItems: 0,
        latestListName: "No lists yet",
        latestListItemCount: 0,
        latestListCollectedCount: 0
    )
}
