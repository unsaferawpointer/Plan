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

	func present(content: NSViewController?, detail: NSViewController)
}

/// AppRouter of the App
final class AppRouter: NSObject {

	// MARK: - UI-Properties

	private var mainWindow: NSWindow

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
	}

	func present(content: NSViewController?, detail: NSViewController) {
		let count = splitViewController.splitViewItems.count

		switch (count, content) {
		case (2, .some(let content)):
			let item = NSSplitViewItem(viewController: content)
			item.minimumThickness = 180
			item.maximumThickness = 200
			splitViewController.insertSplitViewItem(item, at: 1)
		case (3, .some(let content)):
			break
		case (2, .none):
			break
		case (3, .none):
			let item = splitViewController.splitViewItems[1]
			splitViewController.removeSplitViewItem(item)
		default:
			break
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
