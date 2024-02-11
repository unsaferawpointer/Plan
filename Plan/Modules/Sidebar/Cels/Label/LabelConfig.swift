//
//  LabelConfig.swift
//  Plan
//
//  Created by Anton Cherkasov on 27.01.2024.
//

import Cocoa

/// Configuration of the label
struct LabelConfig: ViewConfiguration {

	typealias View = LabelView

	static var reuseIdentifier: String = "label"

	/// Cell title
	var title: String

	/// Icon name
	var iconName: String?

	// Icon color
	var iconColor: NSColor?

	var isEditable: Bool = false
}

// MARK: - Equatable
extension LabelConfig: Equatable {

	static func == (lhs: LabelConfig, rhs: LabelConfig) -> Bool {
		return	lhs.title == rhs.title && lhs.iconName == rhs.iconName && lhs.isEditable == rhs.isEditable
	}
}
