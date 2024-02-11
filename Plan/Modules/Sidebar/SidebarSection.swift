//
//  SidebarSection.swift
//  Plan
//
//  Created by Anton Cherkasov on 10.02.2024.
//

import Foundation

final class SidebarSection {
	
	var title: String
	var items: [SidebarItem]

	init(title: String, items: [SidebarItem]) {
		self.title = title
		self.items = items
	}
}
