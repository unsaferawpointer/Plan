//
//  PlanLocalizationMock.swift
//  PlanTests
//
//  Created by Anton Cherkasov on 31.08.2024.
//

@testable import Plan

final class PlanLocalizationMock {

	var stubs = Stubs()
}

// MARK: - PlanLocalizationProtocol
extension PlanLocalizationMock: PlanLocalizationProtocol {

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
	
	var estimationColumnTitle: String {
		stubs.estimationColumnTitle
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
	}
}
