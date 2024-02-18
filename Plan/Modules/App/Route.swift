//
//  Route.swift
//  Plan
//
//  Created by Anton Cherkasov on 27.01.2024.
//

import Foundation

enum Route {
	case inbox
	case backlog
	case favorites
	case archieve
	case list(_ id: UUID)
}

// MARK: - Hashable
extension Route: Hashable { }
