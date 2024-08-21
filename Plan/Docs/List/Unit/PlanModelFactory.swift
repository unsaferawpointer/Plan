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

final class PlanModelFactory { }

// MARK: - ListModelFactoryProtocol
extension PlanModelFactory: PlanModelFactoryProtocol {

	func makeModel(item: ItemContent, info: HierarchySnapshot.Info) -> HierarchyModel {
		let menu = makeMenu(
			isDone: info.isDone,
			isFavorite: item.isFavorite,
			isLeaf: info.isLeaf
		)

		let content = makeContent(
			isDone: info.isDone,
			text: item.text,
			isFavorite: item.isFavorite,
			icon: item.iconName,
			isLeaf: info.isLeaf,
			number: info.number
		)

		return HierarchyModel(uuid: item.uuid, content: content, menu: menu)
	}
}

// MARK: - Helpers
private extension PlanModelFactory {

	func makeContent(isDone: Bool, text: String, isFavorite: Bool, icon: String?, isLeaf: Bool, number: Int) -> HierarchyModel.Content {

		let style = makeStyle(isDone: isDone, isFavorite: isFavorite, icon: icon, isLeaf: isLeaf)
		let textColor: HierarchyModel.Color = isDone ? .secondary : .primary

		return .init(
			isOn: isDone,
			text: text,
			textColor: textColor,
			style: style,
			number: number
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

	func makeStyle(isDone: Bool, isFavorite: Bool, icon: String?, isLeaf: Bool) -> HierarchyModel.Style {

		guard !isLeaf else {
			switch (isDone, isFavorite) {
			case (true, false):
				return .checkbox
			case (true, true):
				return .checkboxWithIcon(icon ?? "star.fill", color: .secondary)
			case (false, true):
				return .checkboxWithIcon("star.fill", color: .yellow)
			case (false, false):
				return .checkbox
			}
		}

		switch (isDone, isFavorite) {
		case (true, false):
			return .icon(icon ?? "doc.text", color: .secondary)
		case (true, true):
			return .icon(icon ?? "star.fill", color: .secondary)
		case (false, true):
			return .icon("star.fill", color: .yellow)
		case (false, false):
			return .icon(icon ?? "doc.text", color: .primary)
		}
	}
}
