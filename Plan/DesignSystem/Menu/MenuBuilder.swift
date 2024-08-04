//
//  MenuBuilder.swift
//  Hierarchy
//
//  Created by Anton Cherkasov on 01.10.2023.
//

import Cocoa

final class MenuBuilder { }

extension MenuBuilder {

	static func makeMenu(withTitle title: String, for items: [MenuBuilder.Item]) -> NSMenu {
		let menu = NSMenu()
		menu.title = title
		for item in items {
			menu.addItem(item.makeItem())
		}
		return menu
	}
}
