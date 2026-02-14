//
//  DashboardScene.swift
//  SimpleShoppingList
//
//  Created by David Thorn on 14.02.2026.
//

import SwiftUI

public struct DashboardScene: View {
    private let serviceContainer: ServiceContainerProtocol

    public init(serviceContainer: ServiceContainerProtocol) {
        self.serviceContainer = serviceContainer
    }

    public var body: some View {
        NavigationStack {
            DashboardView(serviceContainer: serviceContainer)
                .navigationDestination(for: DashboardRoute.self) { route in
                    destination(for: route)
                }
        }
    }

    @ViewBuilder
    private func destination(for route: DashboardRoute) -> some View {
        switch route {
        case .createList:
            ShoppingListEditorView(serviceContainer: serviceContainer, listID: nil)
        }
    }
}

#if DEBUG
#Preview {
    DashboardScene(serviceContainer: ServiceContainer())
}
#endif
