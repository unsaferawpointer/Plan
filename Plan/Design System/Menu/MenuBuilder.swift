//
//  MenuBuilder.swift
//  Plan
//
//  Created by Anton Cherkasov on 03.02.2024.
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
