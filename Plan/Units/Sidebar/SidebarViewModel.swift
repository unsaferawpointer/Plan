//
//  SidebarViewModel.swift
//  Plan
//
//  Created by Anton Cherkasov on 26.10.2024.
//

import Foundation
import Combine
import SwiftUI

final class SidebarViewModel: ObservableObject {

	@Published var selectedItem: SidebarItem.Identifier

	@Published var bookmarks: [SidebarItem] = []

	@Published var totalCount: Int = 0

	private(set) var cancellables: Set<AnyCancellable> = []

	private(set) var provider: AnyStateProvider<PlanDocumentState>

	private(set) var storage: DocumentStorage<PlanContent>

	private(set) var localization: SidebarLocalizationProtocol

	init(
		provider: AnyStateProvider<PlanDocumentState>,
		storage: DocumentStorage<PlanContent>,
		localization: SidebarLocalizationProtocol = SidebarLocalization()
	) {
		self.provider = provider
		self.storage = storage
		self.localization = localization
		self.selectedItem = provider.state.selection
		$selectedItem.sink { identifier in
			provider.modificate { state in
				state.selection = identifier
			}
		}
		.store(in: &cancellables)

		storage.addObservation(for: self) { _, content in

			var items: [SidebarItem] = []

			self.totalCount = content.hierarchy.count
			content.hierarchy.enumerate { node in
				if node.value.isFavorite {
					items.append(
						.init(
							id: .bookmark(id: node.value.id),
							icon: node.value.iconName?.systemName ?? "star.fill",
							color: node.value.iconColor,
							title: node.value.text,
							count: node.count
						)
					)
				}
			}
			withAnimation {
				self.bookmarks = items
			}
		}
	}
}

// MARK: - Computed properties
extension SidebarViewModel {

	var documentLabel: String {
		localization.documentLabel
	}

	var boorkmarksLabel: String {
		localization.bookmarksSectionLabel
	}
}
