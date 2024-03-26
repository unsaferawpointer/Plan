//
//  SidebarMenuLocalization.swift
//  Plan
//
//  Created by Anton Cherkasov on 26.03.2024.
//

import Foundation

protocol SidebarMenuLocalizationProtocol {

	var contextMenuItemNewList: String { get }

	var contextMenuItemDeleteList: String { get }

}

final class SidebarMenuLocalization { }

// MARK: - SidebarMenuLocalizationProtocol
extension SidebarMenuLocalization: SidebarMenuLocalizationProtocol {

	var contextMenuItemNewList: String {
		return String(localized: "sidebar_context_menu_item_new")
	}
	
	var contextMenuItemDeleteList: String {
		return String(localized: "sidebar_context_menu_item_delete")
	}
}

private extension String {

	init(localized: String.LocalizationValue) {
		self.init(localized: localized, table: "SidebarMenuLocalizable")
	}
}
