//
//  LabelConfiguration.swift
//  Plan
//
//  Created by Anton Cherkasov on 23.06.2023.
//

import Cocoa

/// Configuration of the label
struct LabelConfiguration: FieldConfiguration {

	static func == (lhs: LabelConfiguration, rhs: LabelConfiguration) -> Bool {
		return	lhs.title == rhs.title &&
		lhs.iconName == rhs.iconName &&
		lhs.isEditable == rhs.isEditable
	}


	typealias Field = LabelField

	/// Cell title
	var title: String

	/// Icon name
	var iconName: String?

	/// Ability to be edited
	var isEditable: Bool = false

	var titleDidChange: ((String) -> Void)?
}
