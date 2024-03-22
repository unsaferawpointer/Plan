//
//  AppDelegate.swift
//  Plan
//
//  Created by Anton Cherkasov on 14.01.2024.
//

import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {

	var coordinator = Coordinator()

	func applicationDidFinishLaunching(_ aNotification: Notification) {
		coordinator.start()
		NSApplication.shared.menu = makeMenu()
	}

	func applicationWillTerminate(_ aNotification: Notification) {
		// Insert code here to tear down your application
	}

	func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
		return true
	}
}

private extension AppDelegate {

	func makeMenu() -> NSMenu {
		let menu = NSMenu()

		let action = #selector(MenuSupportable.menuItemHasBeenClicked(_:))

		// MARK: - App item

		let appItem = MenuBuilder.makeItem(
			.menu(
				.main,
				content: .init(title: "", keyEquivalent: ""),
				items:
					[
						.custom(.about, content: .init(title: "About Plan", keyEquivalent: "")),
						.separator,
						.custom(.quit, content: .init(title: "Quit Plan", keyEquivalent: "q"))
					]
			),
			target: self,
			action: action
		)
		menu.addItem(appItem)

		// MARK: - File item

		let fileItem = MenuBuilder.makeItem(
			.menu(
				.file,
				content: .init(title: "File", keyEquivalent: ""),
				items:
					[
						.custom(.newTodo, content: .init(title: "New Todo", keyEquivalent: "n")),
						.custom(.newList, content: .init(title: "New List", keyEquivalent: "N"))
					]
			),
			target: nil,
			action: action
		)
		menu.addItem(fileItem)

		// MARK: Editor item

		let editorItem = MenuBuilder.makeItem(
			.menu(
				.editor,
				content: .init(
					title: "Editor",
					keyEquivalent: ""
				),
				items:
					[
						.custom(.focusOn, content: .init(title: "Focus on the task", keyEquivalent: "")),
						.custom(.moveToBacklog, content: .init(title: "Move to backlog", keyEquivalent: "")),
						.separator,
						.custom(.markAsCompleted, content: .init(title: "Mark as Completed", keyEquivalent: "\r")),
						.custom(.markAsCompleted, content: .init(title: "Mark as Incomplete", keyEquivalent: "")),
						.separator,
						.menu(
							.setUrgency,
							content: .init(title: "Priority", keyEquivalent: ""),
							items:
								[
									.custom(.priority(.low), content: .init(title: "Low", keyEquivalent: "1")),
									.custom(.priority(.medium), content: .init(title: "Medium", keyEquivalent: "2")),
									.custom(.priority(.high), content: .init(title: "High", keyEquivalent: "3"))
								]
						),
						.separator,
						.custom(.delete, content: .init(title: "Delete", keyEquivalent: "\u{0008}"))
					]
			),
			target: nil,
			action: action
		)
		menu.addItem(editorItem)

		return menu
	}
}

// MARK: - MenuSupportable
extension AppDelegate: MenuSupportable {

	func menuItemHasBeenClicked(_ sender: NSMenuItem) {
		guard let id = sender.representedObject as? MenuItem.Identifier else {
			return
		}
		switch id {
		case .quit:
			coordinator.quit()
		case .about:
			coordinator.showAboutPanel()
		default:
			break
		}
	}
}

// MARK: - NSMenuItemValidation
extension AppDelegate: NSMenuItemValidation {

	func validateMenuItem(_ menuItem: NSMenuItem) -> Bool {
		guard let id = menuItem.representedObject as? MenuItem.Identifier else {
			return false
		}

		switch id {
		case .main, .about, .quit:
			return true
		default:
			return false
		}
	}
}

extension MenuItem.Identifier {

	static let quit: MenuItem.Identifier = .basic("quit")

	static let about: MenuItem.Identifier = .basic("about")

	static let main: MenuItem.Identifier = .basic("main")

	static let file: MenuItem.Identifier = .basic("file")

	static let editor: MenuItem.Identifier = .basic("editor")
}
