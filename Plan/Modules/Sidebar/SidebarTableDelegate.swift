//
//  SidebarTableDelegate.swift
//  Plan
//
//  Created by Anton Cherkasov on 24.03.2024.
//

import Foundation

protocol SidebarTableDelegate: AnyObject {
	func item(for index: Int) -> SidebarItem
	func sectionItem(for index: Int) -> SidebarItem
}
