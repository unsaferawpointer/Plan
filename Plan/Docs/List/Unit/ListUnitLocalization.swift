//
//  ListUnitLocalization.swift
//  Plan
//
//  Created by Anton Cherkasov on 04.08.2024.
//

import Foundation

protocol ListUnitLocalizationProtocol {
	var allTaskCompleted: String { get }
	var emptyList: String { get }
	func statusMessage(for count: Int) -> String
	func progressText(for progress: Double) -> String
}


final class ListUnitLocalization {


}

// MARK: - ListUnitLocalizationProtocol
extension ListUnitLocalization: ListUnitLocalizationProtocol {

	var allTaskCompleted: String {
		return String(localized: "all_tasks_completed", table: "ListUnitLocalizable")
	}

	var emptyList: String {
		return String(localized: "empty_list", table: "ListUnitLocalizable")
	}

	func statusMessage(for count: Int) -> String {
		return String(localized: "\(count) tasks", table: "ListUnitLocalizable")
	}

	func progressText(for progress: Double) -> String {
		var formatter = NumberFormatter()
		formatter.numberStyle = .percent
		formatter.maximumFractionDigits = 0
		return formatter.string(from: NSNumber(value: progress)) ?? ""
	}
}
