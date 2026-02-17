//
//  ShoppingItemEditorView.swift
//  SimpleShoppingList
//
//  Created by David Thorn on 14.02.2026.
//

import SwiftUI
import SimpleFramework

public struct ShoppingItemEditorView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: ShoppingItemEditorViewModel
    @State private var showDeleteConfirmation: Bool

    public init(serviceContainer: ServiceContainerProtocol, listID: UUID, itemID: UUID?) {
        let vm = ShoppingItemEditorViewModel(
            shoppingService: serviceContainer.shoppingService,
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

            ScrollView {
                VStack(alignment: .leading, spacing: 14) {
                    SimpleHeroCard(
                        title: viewModel.isPersisted ? "Edit Item" : "New Item",
                        message: "Track what you need and how much it costs.",
                        systemImage: viewModel.isPersisted ? "tag.circle.fill" : "plus.circle.fill",
                        tint: AppStyle.accent
                    )

                    SimpleLabeledTextFieldCard(
                        text: $viewModel.name,
                        title: "Item Name",
                        placeholder: "e.g. Apples"
                    )

                    SimpleLabeledTextFieldCard(
                        text: $viewModel.priceText,
                        title: "Price",
                        placeholder: "e.g. 3.50"
                    )
                    .keyboardType(.decimalPad)

                    SimpleFormActionButtons(
                        showSave: viewModel.shouldShowSaveButton,
                        showReset: viewModel.shouldShowResetButton,
                        showDelete: viewModel.shouldShowDeleteButton,
                        onSave: {
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
                        },
                        onReset: {
                            viewModel.resetChanges()
                        },
                        onDelete: {
                            showDeleteConfirmation = true
                        }
                    )
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
            }
            .scrollDismissesKeyboard(.interactively)
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
