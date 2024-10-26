//
//  SidebarView.swift
//  Plan
//
//  Created by Anton Cherkasov on 26.10.2024.
//

import SwiftUI

struct SidebarView: View {

	@ObservedObject var viewModel: SidebarViewModel

	init(viewModel: SidebarViewModel) {
		self.viewModel = viewModel
	}

	var body: some View {
		List(selection: $viewModel.selectedItem) {
			Label("Document", systemImage: "doc.text")
				.listItemTint(.preferred(.accentColor))
				.tag(SidebarItem.Identifier.doc)

			Section("Bookmarks") {
				ForEach(viewModel.bookmarks) { bookmark in
					Label(bookmark.title, systemImage: bookmark.icon)
						.listItemTint(.preferred(.init(nsColor: bookmark.color?.colorValue ?? .controlAccentColor)))
						.tag(bookmark.id)
				}
			}
		}
		.listStyle(.sidebar)
	}
}

#Preview {
	SidebarView(
		viewModel: SidebarViewModel(
			provider: .init(initialState: .init()),
			storage: .init(
				initialState: .empty,
				provider: PlanDataProvider(),
				undoManager: nil
			)
		)
	)
}
