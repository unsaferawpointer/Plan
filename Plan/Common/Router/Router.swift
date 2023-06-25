//
//  Router.swift
//  Plan
//
//  Created by Anton Cherkasov on 03.06.2023.
//

import Cocoa

/// App router interface
protocol Routable {
	/// Show main window
	func showWindowAndOrderFront()
}

/// Router of the App
final class Router: NSObject {

	// MARK: - UI-Properties

	private var mainWindow: NSWindow

	lazy private var toolbar: NSToolbar = {
		let toolbar = NSToolbar(identifier: "toolbar")
		toolbar.sizeMode = .regular
		toolbar.displayMode = .iconOnly
		return toolbar
	}()

	private var splitViewController: NSSplitViewController? {
		mainWindow.contentViewController as? NSSplitViewController
	}

	// MARK: - Initialization

	/// Basic initialization
	override init() {
		self.mainWindow = NSWindow.makeDefault()
		super.init()
		configureUserInterface()
	}
}

// MARK: - Routable
extension Router: Routable {

	func showWindowAndOrderFront() {
		mainWindow.makeKeyAndOrderFront(nil)
	}
}

// MARK: - Helpers
private extension Router {

	func configureUserInterface() {
		let contentViewController = NSSplitViewController()
		let primaryItem = 		makePrimaryItem()
		let supplementaryItem = makeSupplementaryItem()
		let secondaryItem = 	makeSecondaryItem()
		contentViewController.addSplitViewItem(primaryItem)
		contentViewController.addSplitViewItem(supplementaryItem)
		contentViewController.addSplitViewItem(secondaryItem)
		mainWindow.contentViewController = contentViewController
		mainWindow.toolbar = toolbar
	}
}

// MARK: - Items factory
private extension Router {

	func makePrimaryItem() -> NSSplitViewItem {
		let item = NSSplitViewItem(sidebarWithViewController: Primary.Assembly().build())
		item.collapseBehavior = .preferResizingSiblingsWithFixedSplitView
		item.allowsFullHeightLayout = true
		item.titlebarSeparatorStyle = .automatic
		item.collapseBehavior = .default
		item.minimumThickness = 200.0
		item.maximumThickness = 240.0
		item.holdingPriority = .defaultHigh
		return item
	}

	func makeSupplementaryItem() -> NSSplitViewItem {
		let item = NSSplitViewItem(viewController: Supplementary.ViewController { _ in })
		item.collapseBehavior = .preferResizingSiblingsWithFixedSplitView
		item.allowsFullHeightLayout = true
		item.titlebarSeparatorStyle = .automatic
		item.minimumThickness = 260.0
		item.holdingPriority = .defaultHigh
		return item
	}

	func makeSecondaryItem() -> NSSplitViewItem {
		let item = NSSplitViewItem(viewController: Secondary.ViewController { _ in })
		item.collapseBehavior = .preferResizingSplitViewWithFixedSiblings
		item.allowsFullHeightLayout = true
		item.titlebarSeparatorStyle = .automatic
		item.minimumThickness = 180.0
		item.holdingPriority = .defaultLow
		return item
	}
}
