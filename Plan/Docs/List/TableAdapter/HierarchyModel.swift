//
//  HierarchyModel.swift
//  Hierarchy
//
//  Created by Anton Cherkasov on 29.09.2023.
//

import AppKit

struct HierarchyModel {

	var uuid: UUID

	var content: Content

	var menu: MenuItem

	// MARK: - Initialization

	init(
		uuid: UUID = UUID(),
		content: Content,
		menu: MenuItem
	) {
		self.uuid = uuid
		self.content = content
		self.menu = menu
	}
}

// MARK: - Identifiable
extension HierarchyModel: Identifiable {

	var id: UUID {
		return uuid
	}
}

// MARK: - Hashable
extension HierarchyModel: Hashable {

	static func == (lhs: HierarchyModel, rhs: HierarchyModel) -> Bool {
		return lhs.uuid == rhs.uuid
	}

	func hash(into hasher: inout Hasher) {
		hasher.combine(uuid)
	}
}

extension HierarchyModel {

	var hasBadge: Bool {
		return content.number > 0
	}
}

// MARK: - Nested data structs
extension HierarchyModel {

	enum Style: Equatable {
		case checkbox
		case icon(_ name: String, color: Color)
	}

	enum Color {
		case primary
		case secondary
		case yellow
	}

	struct Content {

		var isOn: Bool

		var text: String

		var textColor: Color

		var style: Style

		var number: Int
	}
}

// MARK: - Computed properties
extension HierarchyModel.Style {

	var hasIcon: Bool {
		switch self {
		case .checkbox:
			return false
		default:
			return true
		}
	}

	var isCheckbox: Bool {
		return self == .checkbox
	}
}

// MARK: - Computed properties
extension HierarchyModel.Color {

	var colorValue: NSColor {
		switch self {
		case .primary:
			return .labelColor
		case .secondary:
			return .secondaryLabelColor
		case .yellow:
			return .systemYellow
		}
	}
}
