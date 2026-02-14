//
//  ShoppingListEditorView.swift
//  SimpleShoppingList
//
//  Created by David Thorn on 14.02.2026.
//

import SwiftUI

public struct ShoppingListEditorView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: ShoppingListEditorViewModel
    @State private var showDeleteConfirmation: Bool

    public init(serviceContainer: ServiceContainerProtocol, listID: UUID?) {
        let vm = ShoppingListEditorViewModel(
            shoppingStore: serviceContainer.shoppingStore,
            listID: listID
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
                    Label("List Details", systemImage: "square.and.pencil")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(AppStyle.accent)
                }
                .listRowBackground(AppStyle.formRowBackground)

                Section("Name") {
                    TextField("e.g. Weekly Shop", text: $viewModel.name)
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
