//
//  ShoppingListDetailView.swift
//  SimpleShoppingList
//
//  Created by David Thorn on 14.02.2026.
//

import SwiftUI
import SimpleFramework

public struct ShoppingListDetailView: View {
    @StateObject private var viewModel: ShoppingListDetailViewModel

    private let listID: UUID

    public init(serviceContainer: ServiceContainerProtocol, listID: UUID) {
        self.listID = listID
        let vm = ShoppingListDetailViewModel(shoppingService: serviceContainer.shoppingService, listID: listID)
        self._viewModel = StateObject(wrappedValue: vm)
    }

    public var body: some View {
        ZStack {
            AppStyle.background
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    if viewModel.items.isEmpty {
                        ContentUnavailableView("No Items", systemImage: "basket")
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 24)
                    } else {
                        ForEach(viewModel.items) { item in
                            NavigationLink(value: ShoppingListsRoute.editItem(listID: listID, itemID: item.id)) {
                                SimpleSelectableCardRow(
                                    title: item.name,
                                    subtitle: item.price.formatted(
                                        .currency(code: Locale.current.currency?.identifier ?? "USD")
                                    ),
                                    systemImage: "cart.fill.badge.plus",
                                    tint: AppStyle.success,
                                    isSelected: item.isCollected
                                ) {
                                    Task {
                                        if Task.isCancelled {
                                            return
                                        }

                                        await viewModel.setCollected(!item.isCollected, for: item)
                                    }
                                }
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
            }
        }
        .navigationTitle(viewModel.title)
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                NavigationLink(value: ShoppingListsRoute.editList(listID: listID)) {
                    Image(systemName: "square.and.pencil")
                }
                NavigationLink(value: ShoppingListsRoute.createItem(listID: listID)) {
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
        ShoppingListDetailView(serviceContainer: ServiceContainer(), listID: UUID())
    }
}
#endif
