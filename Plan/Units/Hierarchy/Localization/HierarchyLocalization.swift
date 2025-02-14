//
//  HierarchyLocalization.swift
//  Plan
//
//  Created by Anton Cherkasov on 04.08.2024.
//

import Foundation

protocol HierarchyLocalizationProtocol {
	var emptyList: String { get }
	var newItemTitle: String { get }

	var descriptionColumnTitle: String { get }
	var bookmarkColumnTitle: String { get }

	func formattedDate(for date: Date?, placeholder: String?) -> String
}

final class HierarchyLocalization { }

// MARK: - HierarchyLocalizationProtocol
extension HierarchyLocalization: HierarchyLocalizationProtocol {


	var emptyList: String {
		return String(localized: "empty_list", table: "HierarchyLocalizable")
	}

	var newItemTitle: String {
		return String(localized: "new_item_title", table: "HierarchyLocalizable")
	}

	var descriptionColumnTitle: String {
		return String(localized: "description_table_column", table: "HierarchyLocalizable")
	}

	var bookmarkColumnTitle: String {
		return String(localized: "bookmark_table_column", table: "HierarchyLocalizable")
	}

	func formattedDate(for date: Date?, placeholder: String?) -> String {

		guard let date else {
			return placeholder ?? ""
		}

		let formatter = DateFormatter()
		formatter.dateStyle = .short
		formatter.timeStyle = .short
		formatter.doesRelativeDateFormatting = true

		return formatter.string(from: date)
	}
}
