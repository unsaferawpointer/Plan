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
			let new = makeItem(item, target: target, action: action)
			result.append(new)
		}

		return result
	}

	static func makeItem(_ item: MenuItem, target: AnyObject?, action: Selector) -> NSMenuItem {
		switch item {
		case .menu(let id, let content, let items):
			let new = NSMenuItem()

			new.title = content.title
			new.keyEquivalent = content.keyEquivalent

			new.target = target
			new.action = action
			new.representedObject = id

			let menu = NSMenu()
			menu.title = content.title

			for item in makeItems(items, target: target, action: action) {
				menu.addItem(item)
			}

			new.submenu = menu

			return new
		case .custom(let id, let content):
			let new = NSMenuItem()

			new.title = content.title
			new.keyEquivalent = content.keyEquivalent

			new.target = target
			new.action = action
			new.representedObject = id

			return new
		case .separator:
			let new: NSMenuItem = .separator()
			return new
		}
	}
}

extension MenuItem {

	static var newTodo: MenuItem {
		return .custom(.newTodo, content: .init(title: "New todo", keyEquivalent: "n"))
	}
	static var newList: MenuItem {
		return .custom(.newList, content: .init(title: "New list", keyEquivalent: "N"))
	}
}
