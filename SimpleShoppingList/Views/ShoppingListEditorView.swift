//
//  ShoppingListEditorView.swift
//  SimpleShoppingList
//
//  Created by David Thorn on 14.02.2026.
//

import SwiftUI
import SimpleFramework

public struct ShoppingListEditorView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: ShoppingListEditorViewModel
    @State private var showDeleteConfirmation: Bool

    public init(serviceContainer: ServiceContainerProtocol, listID: UUID?) {
        let vm = ShoppingListEditorViewModel(
            shoppingService: serviceContainer.shoppingService,
            listID: listID
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
                        title: viewModel.isPersisted ? "Edit List" : "New List",
                        message: "Keep your shopping list organized and easy to scan.",
                        systemImage: viewModel.isPersisted ? "square.and.pencil.circle.fill" : "plus.circle.fill",
                        tint: AppStyle.accent
                    )

                    SimpleLabeledTextFieldCard(
                        text: $viewModel.name,
                        title: "List Name",
                        placeholder: "e.g. Weekly Shop"
                    )

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
        .navigationTitle(viewModel.isPersisted ? "Edit List" : "New List")
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
        ShoppingListEditorView(serviceContainer: ServiceContainer(), listID: nil)
    }
}
#endif
