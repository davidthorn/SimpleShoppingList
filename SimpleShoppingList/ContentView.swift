//
//  ContentView.swift
//  SimpleShoppingList
//
//  Created by David Thorn on 14.02.2026.
//

import SwiftUI

public struct ContentView: View {
    private let serviceContainer: ServiceContainerProtocol

    public init(serviceContainer: ServiceContainerProtocol) {
        self.serviceContainer = serviceContainer
    }

    public var body: some View {
        ZStack {
            AppStyle.background
                .ignoresSafeArea()

            TabView {
                DashboardScene(serviceContainer: serviceContainer)
                    .tabItem {
                        Label("Dashboard", systemImage: "chart.bar")
                    }

                ShoppingListsScene(serviceContainer: serviceContainer)
                    .tabItem {
                        Label("Lists", systemImage: "list.bullet")
                    }
            }
            .tint(AppStyle.accent)
        }
    }
}

#if DEBUG
#Preview {
    ContentView(serviceContainer: ServiceContainer())
}
#endif
