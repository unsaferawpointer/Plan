//
//  SidebarLocalization.swift
//  Plan
//
//  Created by Anton Cherkasov on 26.03.2024.
//

import Foundation

protocol SidebarLocalizationProtocol {

	var inFocusItemTitle: String { get }

	var backlogItemTitle: String { get }

	var archieveItemTitle: String { get }

	var sectionTitle: String { get }

	var newListTitle: String { get }
}

final class SidebarLocalization { }

// MARK: - SidebarLocalizationProtocol
extension SidebarLocalization: SidebarLocalizationProtocol {

	var inFocusItemTitle: String {
		return String(localized: "sidebar_item_inFocus")
	}
	
	var backlogItemTitle: String {
		return String(localized: "sidebar_item_backlog")
	}
	
	var archieveItemTitle: String {
		return String(localized: "sidebar_item_archieve")
	}

	var sectionTitle: String {
		return String(localized: "sidebar_section_title")
	}

	var newListTitle: String {
		return String(localized: "sidebar_new_list_title")
	}
}

private extension String {

	init(localized: String.LocalizationValue) {
		self.init(localized: localized, table: "SidebarLocalizable")
	}
}
