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
}
