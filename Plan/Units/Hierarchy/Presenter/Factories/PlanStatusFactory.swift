//
//  PlanStatusFactory.swift
//  Plan
//
//  Created by Anton Cherkasov on 04.08.2024.
//

import Foundation

protocol PlanStatusFactoryProtocol {
	func makeModel(for nodes: [Node<ItemContent>]) -> BottomBar.Model
}

final class PlanStatusFactory {

	var localization: HierarchyLocalizationProtocol

	// MARK: - Initialization

	init(localization: HierarchyLocalizationProtocol = HierarchyLocalization()) {
		self.localization = localization
	}
}

// MARK: - PlanStatusFactoryProtocol
extension PlanStatusFactory: PlanStatusFactoryProtocol {

	func makeModel(for nodes: [Node<ItemContent>]) -> BottomBar.Model {
		let isEmpty = nodes.isEmpty
		let isCompleted = nodes.allSatisfy { $0.allSatisfy(\.isDone, equalsTo: true)}
		if isCompleted && !isEmpty {
			return .init(
				leadingText: localization.allTaskCompleted,
				trailingText: localization.progressText(for: 1),
				progress: 100
			)
		}

		guard !isEmpty else {
			return .init(
				leadingText: localization.emptyList,
				trailingText: localization.progressText(for: 0),
				progress: 0
			)
		}

		let completeCount = nodes.reduce(0) { partialResult, node in
			return partialResult + node.count(where: \.isDone, equalsTo: true)
		}

		let totalCount = nodes.reduce(0) { partialResult, node in
			return node.count + partialResult
		}

		let progress = Double(completeCount) / Double(totalCount) * 100

		return .init(
			leadingText: localization.statusMessage(for: totalCount),
			trailingText: localization.progressText(for: progress / 100),
			progress: progress
		)
	}
}

