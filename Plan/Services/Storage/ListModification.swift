//
//  ListModification.swift
//  Plan
//
//  Created by Anton Cherkasov on 11.02.2024.
//

import Foundation

enum ListModification {
	case setTitle(_ newValue: String)
}

// MARK: - Equatable
extension ListModification: Equatable { }
