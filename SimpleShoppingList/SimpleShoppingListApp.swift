//
//  SimpleShoppingListApp.swift
//  SimpleShoppingList
//
//  Created by David Thorn on 14.02.2026.
//

import SwiftUI

@main
public struct SimpleShoppingListApp: App {
    private let serviceContainer: ServiceContainerProtocol

    public init() {
        self.serviceContainer = ServiceContainer()
    }

    public var body: some Scene {
        WindowGroup {
            ContentView(serviceContainer: serviceContainer)
                .task {
                    if Task.isCancelled {
                        return
                    }

                    await serviceContainer.bootstrapStoreIfNeeded(with: SampleData.defaultLists)
                }
        }
    }
}
