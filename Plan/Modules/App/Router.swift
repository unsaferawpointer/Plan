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
	}

	func present(detail: NSViewController) {
		let count = splitViewController.splitViewItems.count

		if let last = splitViewController.splitViewItems.last {
			splitViewController.removeSplitViewItem(last)

			let item = NSSplitViewItem(viewController: detail)
			splitViewController.addSplitViewItem(item)
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
		return [.flexibleSpace, .createTodo]
	}

	func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
		return [.flexibleSpace, .createTodo]
	}

	func toolbar(_ toolbar: NSToolbar,
				 itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier,
				 willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
		switch itemIdentifier {
		case .createTodo:
			return {
				let item = NSToolbarItem(itemIdentifier: .createTodo)
				item.isNavigational = false
				item.label = "Create todo"
				item.visibilityPriority = .high
				item.view = {
					let button = NSButton()
					button.bezelStyle = .texturedRounded
					button.image = NSImage(systemSymbolName: "plus", accessibilityDescription: nil)
					button.target = self
					button.action = #selector(newTodo(_:))
					return button
				}()
				return item
			}()
		case .trackingSplitItem:
			return NSTrackingSeparatorToolbarItem(identifier: NSToolbarItem.Identifier.trackingSplitItem,
												  splitView: self.splitViewController.splitView,
												  dividerIndex: 1)
		default:
			return nil
		}
	}
}

// MARK: - Actions
private extension AppRouter {

	@objc
	func newTodo(_ sender: Any?) {
		NotificationCenter.default.post(name: .toolbarNewTodoButtonHasBeenClicked, object: nil)
	}
}

extension NSToolbarItem.Identifier {

	static let createTodo = NSToolbarItem.Identifier("createTodo")

	static let trackingSplitItem = NSToolbarItem.Identifier(rawValue: "trackingSplitItem")
}

extension NSNotification.Name {

	static var toolbarNewTodoButtonHasBeenClicked = NSNotification.Name("toolbarNewTodoHasBeenClicked")
}
