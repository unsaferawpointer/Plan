//
//  TableItem.swift
//  Plan
//
//  Created by Anton Cherkasov on 29.02.2024.
//

import Foundation

enum TableItem {
	case header(_ title: String)
	case custom(id: UUID, configuration: TodoCellConfiguration)
}

// MARK: - Hashable
extension TableItem: Hashable { }

extension TableItem {

	var uuid: UUID? {
		switch self {
		case .header:
			return nil
		case .custom(let uuid, _):
			return uuid
		}
	}
}

struct CellElements: OptionSet {

	var rawValue: Int

	static var icon = CellElements(rawValue: 1 << 0)

	static var textfield = CellElements(rawValue: 1 << 1)

	static var trailingLabel = CellElements(rawValue: 1 << 2)
}

extension CellElements: Hashable { }
