//
//  Supplementary.ViewController.swift
//  Plan
//
//  Created by Anton Cherkasov on 03.06.2023.
//

import Cocoa

extension Supplementary {

	/// Supplementary view-controller
	final class ViewController: NSViewController {

		// MARK: - UI-Properties

		lazy var scrollview: NSScrollView = {
			let view = NSScrollView()
			view.borderType = .noBorder
			view.hasHorizontalScroller = false
			view.autohidesScrollers = true
			view.hasVerticalScroller = true
			view.automaticallyAdjustsContentInsets = true
			return view
		}()

		lazy var table: NSTableView = {
			let view = NSTableView()
			view.style = .inset
			view.usesAlternatingRowBackgroundColors = true
			view.allowsMultipleSelection = false
			view.rowHeight = 120.0
			return view
		}()

		// MARK: - Initialization

		/// Basic initialization
		///
		/// - Parameters:
		///    - configure: Configuration closure. Setup unit here.
		init(_ configure: (Supplementary.ViewController) -> Void) {
			super.init(nibName: nil, bundle: nil)
			configure(self)
			configureUserInterface()
			configureConstraints()
		}

		@available(*, unavailable, message: "Use init()")
		required init?(coder: NSCoder) {
			fatalError("init(coder:) has not been implemented")
		}
	}
}

// MARK: - Life-cycle
extension Supplementary.ViewController {

	override func loadView() {
		self.view = NSView()
	}
}

// MARK: - Helpers
private extension Supplementary.ViewController {

	func configureUserInterface() {
		let column = NSTableColumn(identifier: .init("main"))
		column.resizingMask = [.autoresizingMask, .userResizingMask]
		table.addTableColumn(column)
		table.headerView = nil

		scrollview.automaticallyAdjustsContentInsets = true
	}

	func configureConstraints() {
		scrollview.documentView = table

		view.addSubview(scrollview)
		scrollview.translatesAutoresizingMaskIntoConstraints = false

		NSLayoutConstraint.activate(
			[
				scrollview.topAnchor.constraint(equalTo: view.topAnchor),
				scrollview.bottomAnchor.constraint(equalTo: view.bottomAnchor),
				scrollview.leadingAnchor.constraint(equalTo: view.leadingAnchor),
				scrollview.trailingAnchor.constraint(equalTo: view.trailingAnchor)
			]
		)
	}
}
