//
//  MenuBuilder.swift
//  Plan
//
//  Created by Anton Cherkasov on 03.02.2024.
//

import Cocoa

final class MenuBuilder { }

extension MenuBuilder {

	static func makeItems(_ items: [MenuItem], target: AnyObject?, action: Selector) -> [NSMenuItem] {
		var result: [NSMenuItem] = []

		for item in items {
			switch item {
			case .menu(let id, let content, let items):
				let new = NSMenuItem()

				new.title = content.title
				new.keyEquivalent = content.keyEquivalent

				new.target = target
				new.action = action
				new.representedObject = id

				let menu = NSMenu()

				for item in makeItems(items, target: target, action: action) {
					menu.addItem(item)
				}

				new.submenu = menu

				result.append(new)
			case .custom(let id, let content):
				let new = NSMenuItem()

				new.title = content.title
				new.keyEquivalent = content.keyEquivalent

				new.target = target
				new.action = action
				new.representedObject = id

				result.append(new)
			case .separator:
				let new: NSMenuItem = .separator()
				result.append(new)
			}
		}

		return result
	}
}
