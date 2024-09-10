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

		let content = makeContent(for: item, isLeaf: info.isLeaf)

		let formatter = DateFormatter()
		formatter.dateStyle = .medium
		formatter.timeStyle = .short

		let dateCreatedRaw = formatter.string(from: item.created)
		let dateCreated = TextCell.Model(
			configuration: .init(textColor: .secondary, isEditable: false, validation: nil),
			value: dateCreatedRaw
		)

		let dateCompletedRaw = if let date = item.status.completionDate {
			formatter.string(from: date)
		} else {
			"--"
		}

		let dateCompleted = TextCell.Model(
			configuration: .init(textColor: .secondary, isEditable: false, validation: nil),
			value: dateCompletedRaw
		)

		let rawNumber = (info.number > 0) ? "\(info.number)" : ""

		let groupInfo = info.number > 0 ? "\(info.count) items - \(info.number)" : "\(info.count) items"

		let number = TextCell.Model(
			configuration: .init(textColor: info.isLeaf ? .secondary : .tertiary, isEditable: info.isLeaf, validation: .integer),
			value: info.isLeaf ? rawNumber : groupInfo
		)

		return HierarchyModel(
			uuid: item.uuid,
			content: content,
			createdAt: dateCreated,
			completedAt: dateCompleted, 
			value: number,
			menu: menu
		)
	}
}

// MARK: - Helpers
private extension PlanModelFactory {

	func makeContent(for item: ItemContent, isLeaf: Bool) -> PlanItemModel {
		let textColor = self.textColor(for: item)
		let iconColor = self.iconColor(for: item, isLeaf: isLeaf)
		let isOn = isLeaf ? item.isDone : nil
		let icon = self.icon(for: item, isLeaf: isLeaf)

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

	func iconColor(for item: ItemContent, isLeaf: Bool) -> Color? {
		switch (item.isDone, item.isFavorite) {
		case (false, true):
			return .yellow
		default:
			return .tertiary
		}
	}

	func textColor(for item: ItemContent) -> Color {
		return item.isDone ? .secondary : .primary
	}

	func icon(for item: ItemContent, isLeaf: Bool) -> String? {

		if isLeaf && !item.isFavorite {
			return nil
		} else if item.isFavorite {
			return "star.fill"
		}

		return item.iconName?.rawValue
	}
}
