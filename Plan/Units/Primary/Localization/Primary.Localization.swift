//
//  Primary.Localization.swift
//  Plan
//
//  Created by Anton Cherkasov on 24.06.2023.
//

import Cocoa

/// Localization interface of the primary unit
protocol PrimaryLocalization {

	/// Title of the `all` item
	var allItem: String { get }

	/// Title of the `favorite` item
	var favoriteItem: String { get }

	/// Default name of a project
	var defaultProjectName: String { get }

	/// Button title
	var addProjectButtonTitle: String { get }

	/// Title of the `Delete` context menu item
	var deleteContextMenuItemTitle: String { get }
}

extension Primary {

	/// Localization of the unit
	final class Localization { }
}

// MARK: - PrimaryLocalization
extension Primary.Localization: PrimaryLocalization {

	var allItem: String {
		return "all_lists".localized()
	}

	var favoriteItem: String {
		return "favorite".localized()
	}

	var defaultProjectName: String {
		return "default_project_name".localized()
	}

	var addProjectButtonTitle: String {
		return "add_project_button_title".localized()
	}

	var deleteContextMenuItemTitle: String {
		return "delete_context_menu_item_title".localized()
	}
}

private extension String {

	func localized() -> String {
		return NSLocalizedString(self, tableName: "Primary.Localizable", bundle: .main, value: "", comment: "")
	}
}
