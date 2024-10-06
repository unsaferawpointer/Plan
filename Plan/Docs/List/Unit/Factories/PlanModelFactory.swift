//
//  PlanModelFactory.swift
//  Plan
//
//  Created by Anton Cherkasov on 10.08.2024.
//

import Foundation

protocol PlanModelFactoryProtocol {
	func makeModel(item: ItemContent, info: HierarchySnapshot.Info) -> HierarchyModel
}

final class PlanModelFactory { 
	
	var localization: PlanLocalizationProtocol

	// MARK: - Initialization

	init(localization: PlanLocalizationProtocol = PlanLocalization()) {
		self.localization = localization
	}
}

// MARK: - ListModelFactoryProtocol
extension PlanModelFactory: PlanModelFactoryProtocol {

	func makeModel(item: ItemContent, info: HierarchySnapshot.Info) -> HierarchyModel {
		let menu = makeMenu(
			isDone: info.isDone,
			isFavorite: item.isFavorite,
			isLeaf: info.isLeaf
		)

		let content = makeContent(for: item, info: info)

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
			IconModel(value: .init(icon: .flag), configuration: .init(color: color))
		} else {
			IconModel(value: .init(icon: nil), configuration: .init())
		}

		return HierarchyModel(
			uuid: item.uuid,
			content: content,
			createdAt: dateCreated,
			completedAt: dateCompleted, 
			value: value,
			priority: priority,
			menu: menu
		)
	}
}

// MARK: - Helpers
private extension PlanModelFactory {

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

	func makeContent(for item: ItemContent, info: HierarchySnapshot.Info) -> PlanItemModel {
		let textColor = self.textColor(isDone: info.isDone)
		let iconColor = self.iconColor(isDone: info.isDone, isFavorite: item.isFavorite)
		let isOn = info.isLeaf ? info.isDone : nil
		let icon = self.icon(for: item, isLeaf: info.isLeaf)

		return PlanItemModel(
			value: .init(isOn: isOn, text: item.text),
			configuration: .init(textColor: textColor, icon: icon, iconColor: iconColor)
		)
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

	func iconColor(isDone: Bool, isFavorite: Bool) -> Color? {
		switch (isDone, isFavorite) {
		case (false, true):
			return .yellow
		default:
			return .tertiary
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

extension ItemPriority {

	var color: Color? {
		switch self {
		case .medium:
			return .yellow
		case .high:
			return .red
		default:
			return nil
		}
	}
}
