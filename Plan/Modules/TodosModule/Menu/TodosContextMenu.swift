//
//  TodosContextMenu.swift
//  Plan
//
//  Created by Anton Cherkasov on 06.02.2024.
//

import Cocoa

protocol TodosContextMenuProtocol: AnyObject {
	func display(_ projects: [Project])
}
protocol TodosContextMenuOutput: AnyObject {
	func menuWillOpen()
	func menuDidClose()
	func itemHasBeenClicked(_ item: TodosMenuItemIdentifier)
}

final class TodosContextMenu: NSMenu {

	weak var projectsMenu: NSMenu?

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
		let new = NSMenuItem(
			title: "New",
			action: #selector(itemHasBeenClicked(_:)),
			keyEquivalent: ""
		)
		new.target = self
		new.representedObject = TodosMenuItemIdentifier.new
		addItem(new)

		addItem(.separator())

		let complete = NSMenuItem(
			title: "Complete",
			action: #selector(itemHasBeenClicked(_:)),
			keyEquivalent: ""
		)
		complete.target = self
		complete.representedObject = TodosMenuItemIdentifier.complete
		addItem(complete)

		let focusOn = NSMenuItem(
			title: "Focus on",
			action: #selector(itemHasBeenClicked(_:)),
			keyEquivalent: ""
		)
		focusOn.target = self
		focusOn.representedObject = TodosMenuItemIdentifier.focusOn
		addItem(focusOn)

		let bookmark = NSMenuItem(
			title: "Bookmark",
			action: #selector(itemHasBeenClicked(_:)),
			keyEquivalent: ""
		)
		bookmark.target = self
		bookmark.representedObject = TodosMenuItemIdentifier.bookmark
		addItem(bookmark)

		addItem(.separator())

		let projects = NSMenuItem(
			title: "Projects",
			action: #selector(itemHasBeenClicked(_:)),
			keyEquivalent: ""
		)
		projects.target = self

		let projectsMenu = NSMenu()
		projectsMenu.delegate = self
		projects.submenu = projectsMenu

		addItem(projects)

		self.projectsMenu = projectsMenu

		addItem(.separator())

		let delete = NSMenuItem(
			title: "Delete",
			action: #selector(itemHasBeenClicked(_:)),
			keyEquivalent: ""
		)
		delete.target = self
		delete.representedObject = TodosMenuItemIdentifier.delete
		addItem(delete)
	}
}

// MARK: - Actions
extension TodosContextMenu {

	@objc
	func itemHasBeenClicked(_ sender: NSMenuItem) {
		guard let id = sender.representedObject as? TodosMenuItemIdentifier else {
			return
		}
		output?.itemHasBeenClicked(id)
	}
}

// MARK: - TodosContextMenuProtocol
extension TodosContextMenu: TodosContextMenuProtocol {

	func display(_ projects: [Project]) {
		projectsMenu?.removeAllItems()
		for project in projects {
			let item = NSMenuItem(
				title: project.title,
				action: #selector(itemHasBeenClicked(_:)),
				keyEquivalent: ""
			)
			item.target = self
			item.representedObject = TodosMenuItemIdentifier.project(project.uuid)
			projectsMenu?.addItem(item)
		}
	}
}

// MARK: - NSMenuItemValidation
extension TodosContextMenu: NSMenuItemValidation {

	func validateMenuItem(_ menuItem: NSMenuItem) -> Bool {
		return true
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
