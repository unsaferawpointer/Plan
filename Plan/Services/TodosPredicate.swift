//
//  TodosPredicate.swift
//  Plan
//
//  Created by Anton Cherkasov on 17.02.2024.
//

import Foundation

enum TodosPredicate {
	case inProgress
	case backlog
	case isDone
	case isFavorite
	case list(_ id: UUID?)
}
