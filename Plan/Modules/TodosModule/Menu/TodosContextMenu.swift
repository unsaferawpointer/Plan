//
//  TodosContextMenu.swift
//  Plan
//
//  Created by Anton Cherkasov on 06.02.2024.
//

import Cocoa

protocol TodosMenuItemValidation {
	func validateItem(_ item: MenuItem.Identifier) -> Bool
	func itemState(_ item: MenuItem.Identifier)
}

protocol TodosContextMenuProtocol: AnyObject {
	func display(_ items: [MenuItem])
}
protocol TodosContextMenuOutput: AnyObject {
	func menuWillOpen()
	func menuDidClose()
	func itemHasBeenClicked(_ item: MenuItem.Identifier)
	func validateItem(_ item: MenuItem.Identifier) -> Bool
}

final class TodosContextMenu: NSMenu {

	weak var listsMenu: NSMenu?

	var output: TodosContextMenuOutput?

	init() {
		super.init(title: "")
		configureItems()
	}

	required init(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

// MARK: - Helpers
private extension TodosContextMenu {

	func configureItems() {
		self.delegate = self
	}
}

// MARK: - Actions
extension TodosContextMenu {

	@objc
	func itemHasBeenClicked(_ sender: NSMenuItem) {
		guard let id = sender.representedObject as? MenuItem.Identifier else {
			return
		}
		output?.itemHasBeenClicked(id)
	}
}

// MARK: - TodosContextMenuProtocol
extension TodosContextMenu: TodosContextMenuProtocol {

	func display(_ items: [MenuItem]) {
		removeAllItems()
		for item in MenuBuilder.makeItems(items, target: self, action: #selector(itemHasBeenClicked(_:))) {
			addItem(item)
		}
	}
}

// MARK: - NSMenuItemValidation
extension TodosContextMenu: NSMenuItemValidation {

	func validateMenuItem(_ menuItem: NSMenuItem) -> Bool {
		guard let id = menuItem.representedObject as? MenuItem.Identifier, let output else {
			return false
		}
		return output.validateItem(id)
	}
}

// MARK: - NSMenuDelegate
extension TodosContextMenu: NSMenuDelegate {

	func menuWillOpen(_ menu: NSMenu) {
		output?.menuWillOpen()
	}

	func menuDidClose(_ menu: NSMenu) {
		output?.menuDidClose()
	}
}

extension MenuItem.Identifier {

	static let newTodo: MenuItem.Identifier = .basic("newTodo")

	static let bookmark: MenuItem.Identifier = .basic("bookmark")

	static let unbookmark: MenuItem.Identifier = .basic("unbookmark")

	static let markAsCompleted: MenuItem.Identifier = .basic("mark_as_completed")

	static let markAsIncomplete: MenuItem.Identifier = .basic("mark_as_incomplete")

	static let complete: MenuItem.Identifier = .basic("complete")

	static let moveToList: MenuItem.Identifier = .basic("move_to_list")

	static let delete: MenuItem.Identifier = .basic("delete")
}
