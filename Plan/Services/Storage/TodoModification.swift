//
//  TodoModification.swift
//  Plan
//
//  Created by Anton Cherkasov on 03.02.2024.
//

import Foundation

enum TodoModification {
	case setText(_ newValue: String)
	case setStatus(_ newValue: Bool)
	case focus
	case unfocus
	case bookmark
	case unbookmark
	case setProject(_ newValue: UUID?)
}

// MARK: - Equatable
extension TodoModification: Equatable { }
