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

	// MARK: - Core Data stack

	lazy var persistentContainer: NSPersistentCloudKitContainer = {
		/*
		 The persistent container for the application. This implementation
		 creates and returns a container, having loaded the store for the
		 application to it. This property is optional since there are legitimate
		 error conditions that could cause the creation of the store to fail.
		 */
		let container = NSPersistentCloudKitContainer(name: "Plan")
		container.loadPersistentStores(completionHandler: { (storeDescription, error) in
			if let error = error {
				// Replace this implementation with code to handle the error appropriately.
				// fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

				/*
				 Typical reasons for an error here include:
				 * The parent directory does not exist, cannot be created, or disallows writing.
				 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
				 * The device is out of space.
				 * The store could not be migrated to the current model version.
				 Check the error message to determine what the actual problem was.
				 */
				fatalError("Unresolved error \(error)")
			}
		})
		return container
	}()

	// MARK: - Core Data Saving and Undo support

	func save() {
		// Performs the save action for the application, which is to send the save: message to the application's managed object context. Any encountered errors are presented to the user.
		let context = persistentContainer.viewContext

		if !context.commitEditing() {
			NSLog("\(NSStringFromClass(type(of: self))) unable to commit editing before saving")
		}
		if context.hasChanges {
			do {
				try context.save()
			} catch {
				// Customize this code block to include application-specific recovery steps.
				let nserror = error as NSError
				NSApplication.shared.presentError(nserror)
			}
		}
	}

	func windowWillReturnUndoManager(window: NSWindow) -> UndoManager? {
		// Returns the NSUndoManager for the application. In this case, the manager returned is that of the managed object context for the application.
		return persistentContainer.viewContext.undoManager
	}

	func applicationShouldTerminate(_ sender: NSApplication) -> NSApplication.TerminateReply {
		// Save changes in the application's managed object context before the application terminates.
		let context = persistentContainer.viewContext

		if !context.commitEditing() {
			NSLog("\(NSStringFromClass(type(of: self))) unable to commit editing to terminate")
			return .terminateCancel
		}

		if !context.hasChanges {
			return .terminateNow
		}

		do {
			try context.save()
		} catch {
			let nserror = error as NSError

			// Customize this code block to include application-specific recovery steps.
			let result = sender.presentError(nserror)
			if (result) {
				return .terminateCancel
			}

			let question = NSLocalizedString("Could not save changes while quitting. Quit anyway?", comment: "Quit without saves error question message")
			let info = NSLocalizedString("Quitting now will lose any changes you have made since the last successful save", comment: "Quit without saves error question info");
			let quitButton = NSLocalizedString("Quit anyway", comment: "Quit anyway button title")
			let cancelButton = NSLocalizedString("Cancel", comment: "Cancel button title")
			let alert = NSAlert()
			alert.messageText = question
			alert.informativeText = info
			alert.addButton(withTitle: quitButton)
			alert.addButton(withTitle: cancelButton)

			let answer = alert.runModal()
			if answer == .alertSecondButtonReturn {
				return .terminateCancel
			}
		}
		// If we got here, it is time to quit.
		return .terminateNow
	}

}

private extension AppDelegate {

	func makeMenu() -> NSMenu {
		let menu = NSMenu()

		let action = #selector(MenuSupportable.menuItemHasBeenClicked(_:))

		// MARK: - App item

		let appItem = MenuBuilder.makeItem(
			.menu(
				.basic("main"),
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
				.basic("file"),
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
				.basic("editor"),
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
									.custom(.lowPriority, content: .init(title: "Low", keyEquivalent: "1")),
									.custom(.mediumPriority, content: .init(title: "Medium", keyEquivalent: "2")),
									.custom(.highPriority, content: .init(title: "High", keyEquivalent: "3"))
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
		case .about, .quit:
			return true
		default:
			return false
		}
	}
}

extension MenuItem.Identifier {

	static let quit: MenuItem.Identifier = .basic("quit")

	static let about: MenuItem.Identifier = .basic("about")
}
