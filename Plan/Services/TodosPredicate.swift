//
//  TodosPredicate.swift
//  Plan
//
//  Created by Anton Cherkasov on 17.02.2024.
//

import Foundation

enum TodosPredicate {
	case status(_ value: TodoStatus)
	case list(_ id: UUID?)
}
