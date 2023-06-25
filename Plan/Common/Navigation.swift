//
//  Navigation.swift
//  Plan
//
//  Created by Anton Cherkasov on 25.06.2023.
//

import Foundation

/// Sidebar navigation
enum Navigation {
	case all
	case favorite
	case project(_ id: UUID)
}

// MARK: - Hashable
extension Navigation: Hashable { }
