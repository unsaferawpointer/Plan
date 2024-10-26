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

	private(set) var cancellables: Set<AnyCancellable> = []

	private(set) var provider: AnyStateProvider<PlanDocumentState>

	private(set) var storage: DocumentStorage<PlanContent>

	init(provider: AnyStateProvider<PlanDocumentState>, storage: DocumentStorage<PlanContent>) {
		self.provider = provider
		self.storage = storage
		self.selectedItem = provider.state.selection
		$selectedItem.sink { identifier in
			provider.modificate { state in
				state.selection = identifier
			}
		}
		.store(in: &cancellables)

		storage.addObservation(for: self) { _, content in

			var items: [SidebarItem] = []

			content.hierarchy.enumerate { node in
				if node.value.isFavorite {
					items.append(
						.init(
							id: .bookmark(id: node.value.id),
							icon: node.value.iconName?.systemName ?? "star.fill",
							color: node.value.iconColor,
							title: node.value.text
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
