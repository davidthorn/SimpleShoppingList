//
//  ShoppingItemEditorView.swift
//  SimpleShoppingList
//
//  Created by David Thorn on 14.02.2026.
//

import SwiftUI

public struct ShoppingItemEditorView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: ShoppingItemEditorViewModel
    @State private var showDeleteConfirmation: Bool

    public init(serviceContainer: ServiceContainerProtocol, listID: UUID, itemID: UUID?) {
        let vm = ShoppingItemEditorViewModel(
            shoppingStore: serviceContainer.shoppingStore,
            listID: listID,
            itemID: itemID
        )
        self._viewModel = StateObject(wrappedValue: vm)
        self._showDeleteConfirmation = State(initialValue: false)
    }

    public var body: some View {
        ZStack {
            AppStyle.background
                .ignoresSafeArea()

            Form {
                Section {
                    Label("Item Details", systemImage: "tag.fill")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(AppStyle.accent)
                }
                .listRowBackground(AppStyle.formRowBackground)

                Section("Item") {
                    TextField("e.g. Apples", text: $viewModel.name)
                }
                .listRowBackground(AppStyle.formRowBackground)

                Section("Price") {
                    TextField("e.g. 3.50", text: $viewModel.priceText)
                        .keyboardType(.decimalPad)
                }
                .listRowBackground(AppStyle.formRowBackground)

                Section {
                    if viewModel.shouldShowSaveButton {
                        Button("Save") {
                            Task {
                                if Task.isCancelled {
                                    return
                                }

                                await viewModel.save()
                                if Task.isCancelled {
                                    return
                                }
                                dismiss()
                            }
                        }
                    }

                    if viewModel.shouldShowResetButton {
                        Button("Reset") {
                            viewModel.resetChanges()
                        }
                    }

                    if viewModel.shouldShowDeleteButton {
                        Button("Delete", role: .destructive) {
                            showDeleteConfirmation = true
                        }
                    }
                }
                .listRowBackground(AppStyle.formRowBackground)
            }
            .scrollContentBackground(.hidden)
            .background(AppStyle.formBackground)
        }
        .tint(AppStyle.accent)
        .navigationTitle(viewModel.isPersisted ? "Edit Item" : "New Item")
        .alert("Are you sure you want to delete this?", isPresented: $showDeleteConfirmation) {
            Button("Cancel", role: .cancel) {}
            Button("Delete", role: .destructive) {
                Task {
                    if Task.isCancelled {
                        return
                    }

                    await viewModel.delete()
                    if Task.isCancelled {
                        return
                    }
                    dismiss()
                }
            }
        }
    }
}

#if DEBUG
#Preview {
    NavigationStack {
        ShoppingItemEditorView(serviceContainer: ServiceContainer(), listID: UUID(), itemID: nil)
    }
}
#endif
