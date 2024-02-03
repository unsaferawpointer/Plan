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
	case bookmark
	case unbookmark
}

// MARK: - Equatable
extension TodoModification: Equatable { }
