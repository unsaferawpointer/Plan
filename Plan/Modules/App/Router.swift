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

	func presentDetail(_ viewController: NSViewController)
}

/// AppRouter of the App
final class AppRouter: NSObject {

	// MARK: - UI-Properties

	private var mainWindow: NSWindow

	private var splitViewController: NSSplitViewController? {
		mainWindow.contentViewController as? NSSplitViewController
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

	func presentDetail(_ viewController: NSViewController) {
		guard let splitViewController else {
			return
		}

		if splitViewController.splitViewItems.count == 2 {
			let splitItem = splitViewController.splitViewItems[1]
			splitViewController.removeSplitViewItem(splitItem)
		}

		let new = NSSplitViewItem(viewController: viewController)
		splitViewController.addSplitViewItem(new)
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
		item.minimumThickness = 180
		item.maximumThickness = 240
		return item
	}

	func makeDetail(_ viewController: NSViewController) -> NSSplitViewItem {
		let item = NSSplitViewItem(viewController: viewController)
		item.allowsFullHeightLayout = true
		item.titlebarSeparatorStyle = .automatic
		return item
	}
}
