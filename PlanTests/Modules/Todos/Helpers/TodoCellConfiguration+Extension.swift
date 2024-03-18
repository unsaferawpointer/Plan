//
//  TodoCellConfiguration+Extension.swift
//  PlanTests
//
//  Created by Anton Cherkasov on 18.03.2024.
//

@testable import Plan

extension TodoCellConfiguration {

	static var random: TodoCellConfiguration {
		return .init(
			checkboxValue: .random(),
			iconTint: .default,
			iconName: .random,
			text: .random,
			textColor: .primaryText,
			trailingText: .random,
			elements: [.icon, .textfield]
		)
	}
}
