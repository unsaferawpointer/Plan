//
//  TodoModification.swift
//  Plan
//
//  Created by Anton Cherkasov on 03.02.2024.
//

import Foundation

enum TodoModification {
	case setText(_ newValue: String)
	case complete
	case start
	case moveToBacklog
	case bookmark
	case unbookmark
	case setList(_ newValue: UUID?)
}

// MARK: - Equatable
extension TodoModification: Equatable { }
