//
//  PlanColumnsFactory.swift
//  Plan
//
//  Created by Anton Cherkasov on 30.08.2024.
//

import Foundation

protocol PlanColumnsFactoryDelegate: AnyObject {
	func modificate(id: UUID, newText: String, newStatus: Bool?)
}

protocol PlanColumnsFactoryProtocol {
	func makeColumns(delegate: PlanColumnsFactoryDelegate) -> [any TableColumn<HierarchyModel>]
}

final class PlanColumnsFactory {

	var localization: PlanLocalizationProtocol

	// MARK: - Localization

	init(localization: PlanLocalizationProtocol = PlanLocalization()) {
		self.localization = localization
	}
}

// MARK: - PlanColumnsFactoryProtocol
extension PlanColumnsFactory: PlanColumnsFactoryProtocol {

	func makeColumns(delegate: PlanColumnsFactoryDelegate) -> [any TableColumn<HierarchyModel>] {

		let dateCreated = AnyColumn<HierarchyModel, TextCell>(
			identifier: "created_date_table_column",
			title: localization.createdDateColumnTitle,
			keyPath: \.createdAt,
			options: .init(minWidth: 200, maxWidth: 240, isRequired: false, isHidden: true)
		)

		let dateCompleted = AnyColumn<HierarchyModel, TextCell>(
			identifier: "completed_date_table_column",
			title: localization.completedDateColumnTitle,
			keyPath: \.completedAt,
			options: .init(minWidth: 200, maxWidth: 240, isRequired: false, isHidden: true)
		)

		let main = AnyColumn<HierarchyModel, PlanItemCell>(
			identifier: "description_table_column",
			title: localization.descriptionColumnTitle,
			keyPath: \.content,
			options: .init(minWidth: 320, maxWidth: nil, isRequired: true, isHidden: false)) { [weak delegate] id, value in
				delegate?.modificate(id: id, newText: value.text, newStatus: value.isOn)
			}

		let estimation = AnyColumn<HierarchyModel, BadgeCell>(
			identifier: "estimation_table_column",
			title: localization.estimationColumnTitle,
			keyPath: \.badge,
			options: .init(minWidth: 56, maxWidth: 72, isRequired: false, isHidden: false)
		)

		return [main, estimation, dateCreated, dateCompleted]
	}
}
