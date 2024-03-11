//
//  Router.swift
//  Plan
//
//  Created by Anton Cherkasov on 27.01.2024.
//

import Cocoa

/// App router interface
protocol Routable {

	/// Show main window
	///
	/// - Parameters:
	///    - sidebar: Sidebar view-controller
	///    - detail: Detail view-controller
	func showWindowAndOrderFront(sidebar: NSViewController, detail: NSViewController)

	func present(detail: NSViewController)

	func setWindow(title: String?, subtitle: String?)
}

/// AppRouter of the App
final class AppRouter: NSObject {

	// MARK: - UI-Properties

	private var mainWindow: NSWindow

	private var toolbarItems: [NSToolbarItem] = []

	lazy private var toolbar: NSToolbar = {
		let toolbar = NSToolbar(identifier: "toolbar")
		toolbar.sizeMode = .regular
		toolbar.displayMode = .iconOnly
		toolbar.delegate = self
		return toolbar
	}()

	private var splitViewController: NSSplitViewController {
		guard let controller = mainWindow.contentViewController as? NSSplitViewController else {
			fatalError()
		}
		return controller
	}

	// MARK: - Initialization

	/// Basic initialization
	override init() {
		self.mainWindow = NSWindow.makeDefault()
		super.init()
	}
}

// MARK: - Routable
extension AppRouter: Routable {

	func showWindowAndOrderFront(sidebar: NSViewController, detail: NSViewController) {
		configureUserInterface(sidebar: sidebar, detail: detail)
		mainWindow.makeKeyAndOrderFront(nil)
		self.mainWindow.toolbar = toolbar

		if let toolbarSupportable = detail as? ToolbarSupportable {
			let items = toolbarSupportable.makeToolbarItems()
			updateToolbarItems(newItems: items)
		} else {
			updateToolbarItems(newItems: [])
		}
	}

	func present(detail: NSViewController) {
		if let last = splitViewController.splitViewItems.last {
			splitViewController.removeSplitViewItem(last)

			let item = NSSplitViewItem(viewController: detail)
			splitViewController.addSplitViewItem(item)
		}

		if let toolbarSupportable = detail as? ToolbarSupportable {
			let items = toolbarSupportable.makeToolbarItems()
			updateToolbarItems(newItems: items)
		} else {
			updateToolbarItems(newItems: [])
		}
	}

	func setWindow(title: String?, subtitle: String?) {
		if let title {
			mainWindow.title = title
		}
		if let subtitle {
			mainWindow.subtitle = subtitle
		}
	}
}

// MARK: - Helpers
private extension AppRouter {

	func configureUserInterface(sidebar: NSViewController, detail: NSViewController) {
		let contentViewController = NSSplitViewController()
		let primaryItem = 		makeSidebar(sidebar)
		let secondaryItem = 	makeDetail(detail)
		contentViewController.addSplitViewItem(primaryItem)
		contentViewController.addSplitViewItem(secondaryItem)
		mainWindow.contentViewController = contentViewController
	}
}

// MARK: - Items factory
private extension AppRouter {

	func makeSidebar(_ viewController: NSViewController) -> NSSplitViewItem {
		let item = NSSplitViewItem(sidebarWithViewController: viewController)
		item.allowsFullHeightLayout = true
		item.titlebarSeparatorStyle = .automatic
		item.minimumThickness = 140
		item.maximumThickness = 180
		return item
	}

	func makeDetail(_ viewController: NSViewController) -> NSSplitViewItem {
		let item = NSSplitViewItem(viewController: viewController)
		item.allowsFullHeightLayout = true
		item.titlebarSeparatorStyle = .automatic
		return item
	}
}

// MARK: - NSToolbarDelegate
extension AppRouter: NSToolbarDelegate {

	func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
		return [.toggleSidebarItem] + toolbarItems.map(\.itemIdentifier)
	}

	func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
		return [.toggleSidebarItem] + toolbarItems.map(\.itemIdentifier)
	}

	func toolbar(_ toolbar: NSToolbar,
				 itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier,
				 willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
		switch itemIdentifier {
		case .toggleSidebarItem:
			return {
				let item = NSToolbarItem(itemIdentifier: .toggleSidebarItem)
				item.isNavigational = true
				item.label = "Toggle sidebar"
				item.visibilityPriority = .high
				item.view = {
					let button = NSButton()
					button.bezelStyle = .texturedRounded
					button.image = NSImage(systemSymbolName: "sidebar.leading", accessibilityDescription: nil)
					button.target = self
					button.action = #selector(toggleSidebar(_:))
					return button
				}()
				return item
			}()
		default:
			return toolbarItems.first { $0.itemIdentifier == itemIdentifier }
		}
	}
}

// MARK: - Helpers
private extension AppRouter {

	func updateToolbarItems(newItems: [NSToolbarItem]) {

		guard let toolbar = mainWindow.toolbar else {
			return
		}
		let difference = newItems.difference(from: toolbarItems) { new, old in
			return ObjectIdentifier(new) == ObjectIdentifier(old)
		}
		for change in difference {
			switch change {
			case .remove(let offset, _, _):
				toolbarItems.remove(at: offset)
				toolbar.removeItem(at: offset)
			case .insert(let offset, let item, _):
				toolbarItems.insert(item, at: offset)
				toolbar.insertItem(withItemIdentifier: item.itemIdentifier, at: offset)
			}
		}
	}
}

// MARK: - Actions
private extension AppRouter {

	@objc
	func toggleSidebar(_ sender: Any?) {
		splitViewController.toggleSidebar(sender)
	}
}

extension NSToolbarItem.Identifier {

	static let createTodo = NSToolbarItem.Identifier("createTodo")

	static let trackingSplitItem = NSToolbarItem.Identifier(rawValue: "trackingSplitItem")

	static let toggleSidebarItem = NSToolbarItem.Identifier(rawValue: "toggleSidebar")

	static let groupingItem = NSToolbarItem.Identifier("groupingItem")
}

extension NSNotification.Name {

	static var toolbarNewTodoButtonHasBeenClicked = NSNotification.Name("toolbarNewTodoHasBeenClicked")
}
