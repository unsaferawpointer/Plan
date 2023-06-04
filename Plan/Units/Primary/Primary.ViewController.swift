//
//  Primary.ViewController.swift
//  Plan
//
//  Created by Anton Cherkasov on 04.06.2023.
//

import Cocoa

extension Primary {

	/// Sidebar view-controller
	final class ViewController: NSViewController {

		// MARK: - UI-Properties

		lazy var scrollview: NSScrollView = {
			let view = NSScrollView()
			view.borderType = .noBorder
			view.hasHorizontalScroller = false
			view.autohidesScrollers = true
			view.hasVerticalScroller = true
			view.automaticallyAdjustsContentInsets = true
			view.drawsBackground = false
			return view
		}()

		lazy var table: NSOutlineView = {
			let view = NSOutlineView()
			view.style = .sourceList
			view.focusRingType = .default
			view.rowSizeStyle = .medium
			view.floatsGroupRows = true
			view.allowsMultipleSelection = false
			view.usesAutomaticRowHeights = false
			view.allowsColumnResizing = false
			view.usesAlternatingRowBackgroundColors = false
			return view
		}()

		// MARK: - Initialization

		/// Basic initialization
		///
		/// - Parameters:
		///    - configure: Configuration closure. Setup unit here.
		init(_ configure: (Primary.ViewController) -> Void) {
			super.init(nibName: nil, bundle: nil)
			configure(self)
			configureUserInterface()
//			configureConstraints()
		}

		@available(*, unavailable, message: "Use init()")
		required init?(coder: NSCoder) {
			fatalError("init(coder:) has not been implemented")
		}
	}
}

// MARK: - Life-cycle
extension Primary.ViewController {

	override func loadView() {
		self.view = scrollview
	}
}

// MARK: - Helpers
private extension Primary.ViewController {

	func configureUserInterface() {
		let column = NSTableColumn(identifier: .init("main"))
		column.resizingMask = [.autoresizingMask, .userResizingMask]
		table.addTableColumn(column)
		table.headerView = nil
	}
}
