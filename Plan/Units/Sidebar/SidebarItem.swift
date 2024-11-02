//
//  SidebarItem.swift
//  Plan
//
//  Created by Anton Cherkasov on 26.10.2024.
//

import Foundation

struct SidebarItem {

	var id: Identifier

	var icon: String

	var color: Color?

	var title: String
}

// MARK: - Identifiable
extension SidebarItem: Identifiable { }

// MARK: - Nested data structs
extension SidebarItem {

	enum Identifier: Hashable {
		case doc
		case bookmark(id: UUID)
	}
}