//
//  DashboardView.swift
//  SimpleShoppingList
//
//  Created by David Thorn on 14.02.2026.
//

import SwiftUI

public struct DashboardView: View {
    @StateObject private var viewModel: DashboardViewModel

    public init(serviceContainer: ServiceContainerProtocol) {
        let vm = DashboardViewModel(shoppingStore: serviceContainer.shoppingStore)
        self._viewModel = StateObject(wrappedValue: vm)
    }

    public var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                DashboardCardComponent(
                    title: "Overview",
                    icon: "chart.bar.fill",
                    rows: [
                        ("Total Lists", "\(viewModel.summary.totalLists)"),
                        ("Total Items", "\(viewModel.summary.totalItems)"),
                        ("Collected Items", "\(viewModel.summary.totalCollectedItems)")
                    ]
                )

                DashboardCardComponent(
                    title: "Last Shop",
                    icon: "bag.fill",
                    rows: [
                        ("List", viewModel.summary.latestListName),
                        ("Items", "\(viewModel.summary.latestListItemCount)"),
                        ("Collected", "\(viewModel.summary.latestListCollectedCount)")
                    ]
                )
            }
            .padding()
        }
        .navigationTitle("Dashboard")
        .scrollContentBackground(.hidden)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink(value: DashboardRoute.createList) {
                    Label("Create List", systemImage: "plus")
                }
            }
        }
    }
}

#if DEBUG
#Preview {
    NavigationStack {
        DashboardView(serviceContainer: ServiceContainer())
            .navigationDestination(for: DashboardRoute.self) { _ in
                EmptyView()
            }
    }
}
#endif
