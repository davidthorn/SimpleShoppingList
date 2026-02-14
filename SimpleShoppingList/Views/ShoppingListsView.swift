//
//  ShoppingListsView.swift
//  SimpleShoppingList
//
//  Created by David Thorn on 14.02.2026.
//

import SwiftUI

public struct ShoppingListsView: View {
    @StateObject private var viewModel: ShoppingListsViewModel

    public init(serviceContainer: ServiceContainerProtocol) {
        let vm = ShoppingListsViewModel(shoppingStore: serviceContainer.shoppingStore)
        self._viewModel = StateObject(wrappedValue: vm)
    }

    public var body: some View {
        List {
            if viewModel.lists.isEmpty {
                ContentUnavailableView("No Shopping Lists", systemImage: "cart")
                    .listRowBackground(Color.clear)
            }

            ForEach(viewModel.lists) { list in
                NavigationLink(value: ShoppingListsRoute.detail(listID: list.id)) {
                    ShoppingListRowComponent(list: list)
                }
                .listRowBackground(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(AppStyle.cardFill)
                        .overlay(
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .stroke(AppStyle.cardBorder, lineWidth: 1)
                        )
                        .padding(.vertical, 2)
                )
            }
            .onDelete { offsets in
                Task {
                    for index in offsets {
                        if Task.isCancelled {
                            return
                        }

                        let listID = viewModel.lists[index].id
                        await viewModel.deleteList(id: listID)
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
        .scrollContentBackground(.hidden)
        .navigationTitle("Shopping Lists")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink(value: ShoppingListsRoute.createList) {
                    Image(systemName: "plus")
                }
            }
        }
        .tint(AppStyle.accent)
    }
}

#if DEBUG
#Preview {
    NavigationStack {
        ShoppingListsView(serviceContainer: ServiceContainer())
            .navigationDestination(for: ShoppingListsRoute.self) { _ in
                EmptyView()
            }
    }
}
#endif
