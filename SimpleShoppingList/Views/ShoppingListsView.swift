//
//  ShoppingListsView.swift
//  SimpleShoppingList
//
//  Created by David Thorn on 14.02.2026.
//

import SwiftUI
import SimpleFramework

public struct ShoppingListsView: View {
    @StateObject private var viewModel: ShoppingListsViewModel

    public init(serviceContainer: ServiceContainerProtocol) {
        let vm = ShoppingListsViewModel(shoppingService: serviceContainer.shoppingService)
        self._viewModel = StateObject(wrappedValue: vm)
    }

    public var body: some View {
        ZStack {
            AppStyle.background
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    if viewModel.lists.isEmpty {
                        ContentUnavailableView("No Shopping Lists", systemImage: "cart")
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 24)
                    } else {
                        ForEach(viewModel.lists) { list in
                            NavigationLink(value: ShoppingListsRoute.detail(listID: list.id)) {
                                SimpleRouteRow(
                                    title: list.name,
                                    subtitle: "\(list.collectedCount)/\(list.itemCount) collected",
                                    systemImage: "bag.circle.fill",
                                    tint: AppStyle.accent
                                )
                            }
                            .buttonStyle(.plain)
                            .contextMenu {
                                Button(role: .destructive) {
                                    Task {
                                        if Task.isCancelled {
                                            return
                                        }

                                        await viewModel.deleteList(id: list.id)
                                    }
                                } label: {
                                    Label("Delete List", systemImage: "trash")
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
            }
        }
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
    }
}
#endif
