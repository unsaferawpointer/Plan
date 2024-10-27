//
//  HierarchyLocalization.swift
//  Plan
//
//  Created by Anton Cherkasov on 04.08.2024.
//

import Foundation

protocol HierarchyLocalizationProtocol {
	var allTaskCompleted: String { get }
	var emptyList: String { get }
	var newItemTitle: String { get }
	func statusMessage(for count: Int) -> String
	func progressText(for progress: Double) -> String

	var createdDateColumnTitle: String { get }
	var completedDateColumnTitle: String { get }
	var descriptionColumnTitle: String { get }
	var numberColumnTitle: String { get }
	var priorityColumnTitle: String { get }
	var bookmarkColumnTitle: String { get }

	func formattedDate(for date: Date?, placeholder: String?) -> String
	func valueInfo(count: Int) -> String
	func valueInfo(number: Int) -> String
	func valueInfo(count: Int, number: Int) -> String
}

final class HierarchyLocalization { }

// MARK: - HierarchyLocalizationProtocol
extension HierarchyLocalization: HierarchyLocalizationProtocol {

	var allTaskCompleted: String {
		return String(localized: "all_tasks_completed", table: "HierarchyLocalizable")
	}

	var emptyList: String {
		return String(localized: "empty_list", table: "HierarchyLocalizable")
	}

	var newItemTitle: String {
		return String(localized: "new_item_title", table: "HierarchyLocalizable")
	}

	func statusMessage(for count: Int) -> String {
		return String(localized: "\(count) tasks", table: "HierarchyLocalizable")
	}

	func progressText(for progress: Double) -> String {
		let formatter = NumberFormatter()
		formatter.numberStyle = .percent
		formatter.maximumFractionDigits = 0
		return formatter.string(from: NSNumber(value: progress)) ?? ""
	}

	var createdDateColumnTitle: String {
		return String(localized: "created_date_table_column", table: "HierarchyLocalizable")
	}

	var completedDateColumnTitle: String {
		return String(localized: "completed_date_table_column", table: "HierarchyLocalizable")
	}

	var descriptionColumnTitle: String {
		return String(localized: "description_table_column", table: "HierarchyLocalizable")
	}

	var numberColumnTitle: String {
		return String(localized: "number_table_column", table: "HierarchyLocalizable")
	}

	var priorityColumnTitle: String {
		return String(localized: "priority_table_column", table: "HierarchyLocalizable")
	}

	var bookmarkColumnTitle: String {
		return String(localized: "bookmark_table_column", table: "HierarchyLocalizable")
	}

	func formattedDate(for date: Date?, placeholder: String?) -> String {

		guard let date else {
			return placeholder ?? ""
		}

		let formatter = DateFormatter()
		formatter.dateStyle = .medium
		formatter.timeStyle = .short
		formatter.doesRelativeDateFormatting = true

		return formatter.string(from: date)
	}

	func valueInfo(count: Int) -> String {
		return String(localized: "\(count) items", table: "HierarchyLocalizable")
	}

	func valueInfo(number: Int) -> String {
		return "\(number)"
	}

	func valueInfo(count: Int, number: Int) -> String {
		let prefix = String(localized: "\(count) items", table: "HierarchyLocalizable")
		return prefix + " - \(number)"
	}
}
