//
//  PlanLocalizationMock.swift
//  PlanTests
//
//  Created by Anton Cherkasov on 31.08.2024.
//

import Foundation
@testable import Plan

final class PlanLocalizationMock {

	var stubs = Stubs()
}

// MARK: - HierarchyLocalizationProtocol
extension PlanLocalizationMock: HierarchyLocalizationProtocol {

	var priorityColumnTitle: String {
		stubs.priorityColumnTitle
	}

	var allTaskCompleted: String {
		stubs.allTaskCompleted
	}
	
	var emptyList: String {
		stubs.emptyList
	}
	
	var newItemTitle: String {
		stubs.newItemTitle
	}
	
	func statusMessage(for count: Int) -> String {
		stubs.statusMessage
	}
	
	func progressText(for progress: Double) -> String {
		stubs.progressText
	}
	
	var createdDateColumnTitle: String {
		stubs.createdDateColumnTitle
	}
	
	var completedDateColumnTitle: String {
		stubs.completedDateColumnTitle
	}
	
	var descriptionColumnTitle: String {
		stubs.descriptionColumnTitle
	}
	
	var numberColumnTitle: String {
		stubs.estimationColumnTitle
	}

	func formattedDate(for date: Date?, placeholder: String?) -> String {
		stubs.formattedDate
	}

	func valueInfo(count: Int) -> String {
		stubs.valueInfoForCount
	}

	func valueInfo(number: Int) -> String {
		stubs.valueInfoForNumber
	}

	func valueInfo(count: Int, number: Int) -> String {
		stubs.valueInfoForCountAndNumber
	}
}

// MARK: - Nested data structs
extension PlanLocalizationMock {

	struct Stubs {
		var allTaskCompleted: String = .random
		var emptyList: String = .random
		var newItemTitle: String = .random
		var statusMessage: String = .random
		var progressText: String = .random
		var createdDateColumnTitle: String = .random
		var completedDateColumnTitle: String = .random
		var descriptionColumnTitle: String = .random
		var estimationColumnTitle: String = .random
		var formattedDate: String = .random
		var valueInfoForCount: String = .random
		var valueInfoForNumber: String = .random
		var valueInfoForCountAndNumber: String = .random
		var priorityColumnTitle: String = .random
	}
}
