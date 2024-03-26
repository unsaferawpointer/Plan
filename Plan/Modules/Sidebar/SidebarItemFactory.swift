//
//  SidebarItemFactory.swift
//  Plan
//
//  Created by Anton Cherkasov on 17.03.2024.
//

import Foundation

protocol SidebarItemsFactoryProtocol {
	func makeStaticContent() -> [SidebarItem]
	func makeDynamicContent(from lists: [List]) -> [SidebarItem]
	func makeSectionTitle() -> String
	func makeNewListTitle() -> String
}

final class SidebarItemFactory {

	var localization: SidebarLocalizationProtocol

	// MARK: - Initialization

	init(localization: SidebarLocalizationProtocol) {
		self.localization = localization
	}

}

// MARK: - SidebarItemFactoryProtocol
extension SidebarItemFactory: SidebarItemsFactoryProtocol {

	func makeNewListTitle() -> String {
		return localization.newListTitle
	}

	func makeSectionTitle() -> String {
		return localization.sectionTitle
	}

	func makeDynamicContent(from lists: [List]) -> [SidebarItem] {
		return lists.map { list in
			SidebarItem(
				id: .list(list.uuid),
				icon: "list.bullet",
				tintColor: .monochrome,
				title: list.title,
				isEditable: true
			)
		}
	}

	func makeStaticContent() -> [SidebarItem] {
		return [makeInFocus(), makeBacklog(), makeArchieve()]
	}
}

private extension SidebarItemFactory {

	func makeInFocus() -> SidebarItem {
		return .init(
			id: .inFocus,
			icon: "sparkles",
			tintColor: .yellow,
			title: localization.inFocusItemTitle,
			isEditable: false
		)
	}

	func makeBacklog() -> SidebarItem {
		return .init(
			id: .backlog,
			icon: "square.stack.3d.up",
			tintColor: .monochrome,
			title: localization.backlogItemTitle,
			isEditable: false
		)
	}

	func makeArchieve() -> SidebarItem {
		return .init(
			id: .archieve,
			icon: "shippingbox",
			tintColor: .monochrome,
			title: localization.archieveItemTitle,
			isEditable: false
		)
	}
}
