//
//  TableItem.swift
//  Plan
//
//  Created by Anton Cherkasov on 29.02.2024.
//

import Foundation

enum TableItem {
	case header(_ title: String)
	case custom(_ model: TodoModel)
}

// MARK: - Hashable
extension TableItem: Hashable { }

extension TableItem {

	var uuid: UUID? {
		switch self {
		case .header:
			return nil
		case .custom(let model):
			return model.uuid
		}
	}
}
