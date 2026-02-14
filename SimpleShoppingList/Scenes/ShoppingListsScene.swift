//
//  ShoppingListsScene.swift
//  SimpleShoppingList
//
//  Created by David Thorn on 14.02.2026.
//

import SwiftUI

public struct ShoppingListsScene: View {
    private let serviceContainer: ServiceContainerProtocol

    public init(serviceContainer: ServiceContainerProtocol) {
        self.serviceContainer = serviceContainer
    }

    public var body: some View {
        NavigationStack {
            ShoppingListsView(serviceContainer: serviceContainer)
                .navigationDestination(for: ShoppingListsRoute.self) { route in
                    destination(for: route)
                }
        }
    }

    @ViewBuilder
    private func destination(for route: ShoppingListsRoute) -> some View {
        switch route {
        case .createList:
            ShoppingListEditorView(serviceContainer: serviceContainer, listID: nil)
        case .editList(let listID):
            ShoppingListEditorView(serviceContainer: serviceContainer, listID: listID)
        case .detail(let listID):
            ShoppingListDetailView(serviceContainer: serviceContainer, listID: listID)
        case .createItem(let listID):
            ShoppingItemEditorView(serviceContainer: serviceContainer, listID: listID, itemID: nil)
        case .editItem(let listID, let itemID):
            ShoppingItemEditorView(serviceContainer: serviceContainer, listID: listID, itemID: itemID)
        }
    }
}

#if DEBUG
#Preview {
    ShoppingListsScene(serviceContainer: ServiceContainer())
}
#endif
