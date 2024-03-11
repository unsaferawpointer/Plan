//
//  MenuItem.swift
//  Plan
//
//  Created by Anton Cherkasov on 03.02.2024.
//

import Foundation

enum MenuItem {
	case menu(_ id: Identifier, content: ItemContent, items: [MenuItem])
	case custom(_ id: Identifier, content: ItemContent)
	case separator
}

// MARK: - Nested data strcuts
extension MenuItem {

	enum Identifier {

		case list(_ value: UUID)
		case grouping(_ value: TodosGrouping)
		case priority(_ value: Priority)
		case basic(_ value: String)
	}

	struct ItemContent {
		var title: String
		var keyEquivalent: String
	}
}

// MARK: - Equatable
extension MenuItem.Identifier: Equatable { }
