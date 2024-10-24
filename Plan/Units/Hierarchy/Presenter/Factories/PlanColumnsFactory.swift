//
//  PlanColumnsFactory.swift
//  Plan
//
//  Created by Anton Cherkasov on 30.08.2024.
//

import Foundation

protocol PlanColumnsFactoryDelegate: AnyObject {
	func modificate(id: UUID, newText: String, newStatus: Bool?)
	func modificate(id: UUID, value: Int)
}

protocol PlanColumnsFactoryProtocol {
	func makeColumns(delegate: PlanColumnsFactoryDelegate) -> [any TableColumn<ItemViewModel>]
}

final class PlanColumnsFactory {

	var localization: HierarchyLocalizationProtocol

	// MARK: - Localization

	init(localization: HierarchyLocalizationProtocol = HierarchyLocalization()) {
		self.localization = localization
	}
}

// MARK: - PlanColumnsFactoryProtocol
extension PlanColumnsFactory: PlanColumnsFactoryProtocol {

	func makeColumns(delegate: PlanColumnsFactoryDelegate) -> [any TableColumn<ItemViewModel>] {

		let dateCreated = AnyColumn<ItemViewModel, TextCell>(
			identifier: "created_date_table_column",
			title: localization.createdDateColumnTitle,
			keyPath: \.createdAt,
			options: .init(minWidth: 200, maxWidth: 240, isRequired: false, isHidden: true)
		)

		let dateCompleted = AnyColumn<ItemViewModel, TextCell>(
			identifier: "completed_date_table_column",
			title: localization.completedDateColumnTitle,
			keyPath: \.completedAt,
			options: .init(minWidth: 200, maxWidth: 240, isRequired: false, isHidden: true)
		)

		let main = AnyColumn<ItemViewModel, ItemCell>(
			identifier: "description_table_column",
			title: localization.descriptionColumnTitle,
			keyPath: \.content,
			options: .init(minWidth: 320, maxWidth: nil, isRequired: true, isHidden: false)) { [weak delegate] id, value in
				delegate?.modificate(id: id, newText: value.text, newStatus: value.isOn)
			}

		let value = AnyColumn<ItemViewModel, TextCell>(
			identifier: "value_table_column",
			title: localization.numberColumnTitle,
			keyPath: \.value,
			options: .init(minWidth: 160, maxWidth: 160, isRequired: false, isHidden: false)
		) { [weak delegate] id, value in
			delegate?.modificate(id: id, value: Int(value) ?? 0)
		}

		let priority = AnyColumn<ItemViewModel, IconCell>(
			identifier: "priority_table_column",
			title: localization.priorityColumnTitle,
			keyPath: \.priority,
			options: .init(minWidth: 56, maxWidth: 56, isRequired: false, isHidden: false)
		)

		return [main, value, priority, dateCreated, dateCompleted]
	}
}
