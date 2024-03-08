//
//  TodoCellConfiguration.swift
//  Plan
//
//  Created by Anton Cherkasov on 08.03.2024.
//

import Foundation

struct TodoCellConfiguration {

	var checkboxValue: Bool

	var iconTint: TintColor

	var iconName: String

	var text: String

	var textColor: TintColor

	var trailingText: String

	var elements: CellElements

}

// MARK: - Hashable
extension TodoCellConfiguration: Hashable { }

// MARK: - Nested data structs
extension TodoCellConfiguration {

}
