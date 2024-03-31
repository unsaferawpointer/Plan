//
//  TodosAction.swift
//  Plan
//
//  Created by Anton Cherkasov on 03.02.2024.
//

import Foundation

enum TodosAction {
	case insertTodos(_ texts: [String])
	case insertTodo(_ id: UUID, text: String)
	case delete(_ ids: [UUID])
}

// MARK: - Equatable
extension TodosAction: Equatable { }
