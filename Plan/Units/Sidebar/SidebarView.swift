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
			Label(viewModel.documentLabel, systemImage: "doc.text")
				.listItemTint(.preferred(.accentColor))
				.badge(viewModel.totalCount)
				.accessibilityIdentifier("sidebar_label")
				.tag(SidebarItem.Identifier.doc)

			Section {
				ForEach(viewModel.bookmarks) { bookmark in
					Label(bookmark.title, systemImage: bookmark.icon)
						.listItemTint(
							.preferred(
								.init(nsColor: bookmark.color?.colorValue ?? .controlAccentColor)
							)
						)
						.badge(bookmark.count)
						.accessibilityIdentifier("sidebar_label")
						.tag(bookmark.id)
				}
			} header: {
				Text(viewModel.boorkmarksLabel)
					.accessibilityIdentifier("sidebar_section")
			}

		}
		.listStyle(.sidebar)
		.accessibilityIdentifier("sidebar")
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
			),
			localization: SidebarLocalization()
		)
	)
}
