//
//  SidebarAction.swift
//  Plan
//
//  Created by Anton Cherkasov on 11.02.2024.
//

import Foundation

enum SidebarAction {
	case insert(_ id: UUID, title: String)
	case delete(_ ids: [UUID])
}

// MARK: - Equatable
extension SidebarAction: Equatable { }
