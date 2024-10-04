//
//  PlanLocalization.swift
//  Plan
//
//  Created by Anton Cherkasov on 04.08.2024.
//

import Foundation

protocol PlanLocalizationProtocol {
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

	func formattedDate(for date: Date?, placeholder: String?) -> String
	func valueInfo(count: Int) -> String
	func valueInfo(number: Int) -> String
	func valueInfo(count: Int, number: Int) -> String
}

final class PlanLocalization { }

// MARK: - PlanLocalizationProtocol
extension PlanLocalization: PlanLocalizationProtocol {

	var allTaskCompleted: String {
		return String(localized: "all_tasks_completed", table: "PlanLocalizable")
	}

	var emptyList: String {
		return String(localized: "empty_list", table: "PlanLocalizable")
	}

	var newItemTitle: String {
		return String(localized: "new_item_title", table: "PlanLocalizable")
	}

	func statusMessage(for count: Int) -> String {
		return String(localized: "\(count) tasks", table: "PlanLocalizable")
	}

	func progressText(for progress: Double) -> String {
		let formatter = NumberFormatter()
		formatter.numberStyle = .percent
		formatter.maximumFractionDigits = 0
		return formatter.string(from: NSNumber(value: progress)) ?? ""
	}

	var createdDateColumnTitle: String {
		return String(localized: "created_date_table_column", table: "PlanLocalizable")
	}

	var completedDateColumnTitle: String {
		return String(localized: "completed_date_table_column", table: "PlanLocalizable")
	}

	var descriptionColumnTitle: String {
		return String(localized: "description_table_column", table: "PlanLocalizable")
	}

	var numberColumnTitle: String {
		return String(localized: "number_table_column", table: "PlanLocalizable")
	}

	var priorityColumnTitle: String {
		return String(localized: "priority_table_column", table: "PlanLocalizable")
	}

	func formattedDate(for date: Date?, placeholder: String?) -> String {

		guard let date else {
			return placeholder ?? ""
		}

		let formatter = DateFormatter()
		formatter.dateStyle = .medium
		formatter.timeStyle = .short

		return formatter.string(from: date)
	}

	func valueInfo(count: Int) -> String {
		return String(localized: "\(count) items", table: "PlanLocalizable")
	}

	func valueInfo(number: Int) -> String {
		return "\(number)"
	}

	func valueInfo(count: Int, number: Int) -> String {
		let prefix = String(localized: "\(count) items", table: "PlanLocalizable")
		return prefix + " - \(number)"
	}
}
