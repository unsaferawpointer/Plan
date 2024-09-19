//
//  PlanStatusFactory.swift
//  Plan
//
//  Created by Anton Cherkasov on 04.08.2024.
//

import Foundation

protocol PlanStatusFactoryProtocol {
	func makeModel(for root: Root<ItemContent>) -> BottomBar.Model
}

final class PlanStatusFactory {

	var localization: PlanLocalizationProtocol

	// MARK: - Initialization

	init(localization: PlanLocalizationProtocol = PlanLocalization()) {
		self.localization = localization
	}
}

// MARK: - PlanStatusFactoryProtocol
extension PlanStatusFactory: PlanStatusFactoryProtocol {

	func makeModel(for root: Root<ItemContent>) -> BottomBar.Model {
		let isEmpty = root.nodes.isEmpty
		let isCompleted = root.allSatisfy(\.isDone, equalsTo: true)
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

		let completeCount = root.count(where: \.isDone, equalsTo: true)
		let progress = Double(completeCount) / Double(root.count) * 100

		return .init(
			leadingText: localization.statusMessage(for: root.count),
			trailingText: localization.progressText(for: progress / 100),
			progress: progress
		)
	}
}

