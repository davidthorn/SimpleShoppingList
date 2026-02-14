//
//  ShoppingListDetailView.swift
//  SimpleShoppingList
//
//  Created by David Thorn on 14.02.2026.
//

import SwiftUI

public struct ShoppingListDetailView: View {
    @StateObject private var viewModel: ShoppingListDetailViewModel

    private let listID: UUID

    public init(serviceContainer: ServiceContainerProtocol, listID: UUID) {
        self.listID = listID
        let vm = ShoppingListDetailViewModel(shoppingStore: serviceContainer.shoppingStore, listID: listID)
        self._viewModel = StateObject(wrappedValue: vm)
    }

    public var body: some View {
        List {
            if viewModel.items.isEmpty {
                ContentUnavailableView("No Items", systemImage: "basket")
                    .listRowBackground(Color.clear)
            }

            ForEach(viewModel.items) { item in
                NavigationLink(value: ShoppingListsRoute.editItem(listID: listID, itemID: item.id)) {
                    HStack(spacing: 12) {
                        Image(systemName: "cart.fill.badge.plus")
                            .foregroundStyle(AppStyle.accent)

                        VStack(alignment: .leading, spacing: 4) {
                            Text(item.name)
                            Text(item.price, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                                .font(.subheadline)
                                .foregroundStyle(AppStyle.textSecondary)
                        }
                        Spacer()
                        Button {
                            Task {
                                if Task.isCancelled {
                                    return
                                }

                                await viewModel.setCollected(!item.isCollected, for: item)
                            }
                        } label: {
                            Image(systemName: item.isCollected ? "checkmark.circle.fill" : "circle")
                                .foregroundStyle(item.isCollected ? AppStyle.success : AppStyle.textSecondary)
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.vertical, 8)
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
        }
        .listStyle(.insetGrouped)
        .scrollContentBackground(.hidden)
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
            .navigationDestination(for: ShoppingListsRoute.self) { _ in
                EmptyView()
            }
    }
}
#endif
