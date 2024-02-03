//
//  TodosAction.swift
//  Plan
//
//  Created by Anton Cherkasov on 03.02.2024.
//

import Foundation

enum TodosAction {
	case insert(_ texts: [String])
	case delete(_ ids: [UUID])
}

// MARK: - Equatable
extension TodosAction: Equatable { }
