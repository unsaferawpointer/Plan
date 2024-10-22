//
//  ListUnitViewModelFactory.swift
//  Plan
//
//  Created by Anton Cherkasov on 22.10.2024.
//

import Foundation

protocol ListUnitViewModelFactoryProtocol {
	func makeModel(item: ItemContent) -> ListItemViewModel
}

final class ListUnitViewModelFactory {

	var localization: HierarchyLocalizationProtocol

	// MARK: - Initialization

	init(localization: HierarchyLocalizationProtocol = HierarchyLocalization()) {
		self.localization = localization
	}
}

// MARK: - ListModelFactoryProtocol
extension ListUnitViewModelFactory: ListUnitViewModelFactoryProtocol {

	func makeModel(item: ItemContent) -> ListItemViewModel {
		let menu = makeMenu(
			isDone: item.isDone,
			isFavorite: item.isFavorite,
			isLeaf: true
		)

		let info = HierarchySnapshot.Info(isDone: item.isDone, number: item.count, isLeaf: true, count: 0)

		let status = makeStatus(for: item, info: info)
		let description = makeDescription(for: item, info: info)

		let dateCreated = TextModel(
			configuration: .init(textColor: .secondary),
			value: localization.formattedDate(for: item.created, placeholder: nil)
		)

		let dateCompleted = TextModel(
			configuration: .init(textColor: .secondary),
			value: localization.formattedDate(for: item.status.completionDate, placeholder: "--")
		)

		let value = TextModel(
			configuration: .init(
				textColor: info.isLeaf ? .secondary : .tertiary,
				isEditable: info.isLeaf,
				validation: .integer
			),
			value: valueInfo(number: info.number, count: info.count)
		)

		let priority: IconModel = if let color = item.priority.color, info.isLeaf {
			IconModel(value: .init(icon: .flag), configuration: .init(color: info.isDone ? .tertiary : color))
		} else {
			IconModel(value: .init(icon: nil), configuration: .init())
		}

		return ListItemViewModel(
			uuid: item.uuid,
			status: status,
			description: description,
			createdAt: dateCreated,
			completedAt: dateCompleted,
			value: value,
			priority: priority,
			menu: menu
		)
	}
}

// MARK: - Helpers
private extension ListUnitViewModelFactory {

	func valueInfo(number: Int, count: Int) -> String {

		let isLeaf = count == 0

		guard !isLeaf else {
			return number > 0 ? localization.valueInfo(number: number) : ""
		}

		guard number > 0 else {
			return localization.valueInfo(count: count)
		}

		return localization.valueInfo(count: count, number: number)
	}

	func makeDescription(for item: ItemContent, info: HierarchySnapshot.Info) -> TextModel {
		let textColor = self.textColor(isDone: info.isDone)
		return TextModel(
			configuration: .init(
				textColor: textColor,
				isEditable: true,
				validation: nil
			),
			value: .init(item.text)
		)
	}

	func makeStatus(for item: ItemContent, info: HierarchySnapshot.Info) -> CheckboxCellModel {
		return CheckboxCellModel(value: .init(isOn: item.isDone), configuration: .init())
	}

	func makeMenu(isDone: Bool, isFavorite: Bool, isLeaf: Bool) -> MenuItem {
		return MenuItem(
			state:
				[
					"set_status_menu_item" : isDone ? .on : .off,
					"bookmark_menu_item" : isFavorite ? .on : .off
				],
			validation:
				[
					"set_status_menu_item" : true,
					"bookmark_menu_item": true,
					"delete_menu_item": true,
					"set_estimation_menu_item": isLeaf
				]
		)
	}

	func iconColor(isDone: Bool, isFavorite: Bool, baseColor: Color?) -> Color? {
		switch (isDone, isFavorite) {
		case (false, true):
			return .yellow
		default:
			return baseColor ?? .tertiary
		}
	}

	func textColor(isDone: Bool) -> Color {
		return isDone ? .secondary : .primary
	}

	func icon(for item: ItemContent, isLeaf: Bool) -> String? {

		if isLeaf && !item.isFavorite {
			return nil
		} else if item.isFavorite {
			return "star.fill"
		}

		return item.iconName?.systemName
	}
}
