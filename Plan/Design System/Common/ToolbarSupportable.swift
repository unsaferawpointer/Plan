//
//  ToolbarSupportable.swift
//  Plan
//
//  Created by Anton Cherkasov on 10.03.2024.
//

import Cocoa

protocol ToolbarSupportable: AnyObject {
	func makeToolbarItems() -> [NSToolbarItem]
}
