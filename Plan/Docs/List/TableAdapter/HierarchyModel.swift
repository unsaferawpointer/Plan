//
//  HierarchyModel.swift
//  Hierarchy
//
//  Created by Anton Cherkasov on 29.09.2023.
//

import AppKit

struct HierarchyModel {

	var uuid: UUID

	var status: Bool

	var text: String

	var style: Style

	var isFavorite: Bool

	var number: Int

	var menu: MenuItem

	var animateIcon: Bool

	var provider: ((UUID) -> TransferNode?)?

	var textDidChange: (String) -> ()

	var statusDidChange: (Bool) -> ()

	// MARK: - Initialization

	init(
		uuid: UUID = UUID(),
		status: Bool,
		text: String,
		style: Style = .checkbox,
		isFavorite: Bool,
		number: Int,
		menu: MenuItem,
		animateIcon: Bool,
		provider: ((UUID) -> TransferNode?)?,
		textDidChange: @escaping (String) -> (),
		statusDidChange: @escaping (Bool) -> ()
	) {
		self.uuid = uuid
		self.status = status
		self.text = text
		self.style = style
		self.isFavorite = isFavorite
		self.number = number
		self.menu = menu
		self.animateIcon = animateIcon
		self.provider = provider
		self.textDidChange = textDidChange
		self.statusDidChange = statusDidChange
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
		return number > 0
	}

	var effectiveIcon: String? {
		switch style {
		case .checkbox:
			return isFavorite ? "star.fill" : nil
		case .list:
			return isFavorite ? "star.fill" : "doc.text"
		case .icon(let name):
			return isFavorite ? "star.fill" : name
		}
	}
}

extension HierarchyModel {

	enum Style: Equatable {
		case checkbox
		case list
		case icon(_ name: String)
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
