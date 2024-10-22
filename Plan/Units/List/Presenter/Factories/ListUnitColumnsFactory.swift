//
//  ListUnitColumnsFactory.swift
//  Plan
//
//  Created by Anton Cherkasov on 22.10.2024.
//

import Foundation

protocol ListUnitColumnsFactoryDelegate: AnyObject {
	func modificated(id: UUID, newText: String)
	func modificate(id: UUID, newStatus: Bool)
	func modificate(id: UUID, value: Int)
}

protocol ListUnitColumnsFactoryProtocol {
	func makeColumns(delegate: ListUnitColumnsFactoryDelegate) -> [any TableColumn<ListItemViewModel>]
}

final class ListUnitColumnsFactory {

	var localization: ListUnitLocalizationProtocol

	// MARK: - Localization

	init(localization: ListUnitLocalizationProtocol = ListUnitLocalization()) {
		self.localization = localization
	}
}

// MARK: - ListUnitColumnsFactoryProtocol
extension ListUnitColumnsFactory: ListUnitColumnsFactoryProtocol {

	func makeColumns(delegate: ListUnitColumnsFactoryDelegate) -> [any TableColumn<ListItemViewModel>] {

		let dateCreated = AnyColumn<ListItemViewModel, TextCell>(
			identifier: "created_date_table_column",
			title: localization.createdDateColumnTitle,
			keyPath: \.createdAt,
			options: .init(minWidth: 200, maxWidth: 240, isRequired: false, isHidden: true)
		)

		let dateCompleted = AnyColumn<ListItemViewModel, TextCell>(
			identifier: "completed_date_table_column",
			title: localization.completedDateColumnTitle,
			keyPath: \.completedAt,
			options: .init(minWidth: 200, maxWidth: 240, isRequired: false, isHidden: true)
		)

		let status = AnyColumn<ListItemViewModel, CheckboxCell>(
			identifier: "status_table_column",
			title: localization.statusColumnTitle,
			keyPath: \.status,
			options: .init(minWidth: 64, maxWidth: 64, isRequired: true, isHidden: false)) { [weak delegate] id, newValue in
				delegate?.modificate(id: id, newStatus: newValue.isOn)
			}

		let description = AnyColumn<ListItemViewModel, TextCell>(
			identifier: "description_table_column",
			title: localization.descriptionColumnTitle,
			keyPath: \.description,
			options: .init(minWidth: 320, maxWidth: nil, isRequired: true, isHidden: false)) { [weak delegate] id, newText in
				delegate?.modificated(id: id, newText: newText)
			}

		let value = AnyColumn<ListItemViewModel, TextCell>(
			identifier: "value_table_column",
			title: localization.numberColumnTitle,
			keyPath: \.value,
			options: .init(minWidth: 160, maxWidth: 160, isRequired: false, isHidden: false)
		) { [weak delegate] id, value in
			delegate?.modificate(id: id, value: Int(value) ?? 0)
		}

		let priority = AnyColumn<ListItemViewModel, IconCell>(
			identifier: "priority_table_column",
			title: localization.priorityColumnTitle,
			keyPath: \.priority,
			options: .init(minWidth: 56, maxWidth: 56, isRequired: false, isHidden: false)
		)

		return [status, description, value, priority, dateCreated, dateCompleted]
	}
}
