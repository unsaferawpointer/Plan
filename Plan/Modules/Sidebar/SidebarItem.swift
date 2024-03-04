//
//  SidebarItem.swift
//  Plan
//
//  Created by Anton Cherkasov on 27.01.2024.
//

import Foundation

struct SidebarItem {
	var id: Route
	var icon: String
	var tintColor: TintColor = .monochrome
	var title: String

	var isEditable: Bool
}

// MARK: - Equatable
extension SidebarItem: Equatable { }
