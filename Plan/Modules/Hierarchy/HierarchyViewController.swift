//
//  HierarchyViewController.swift
//  Plan
//
//  Created by Anton Cherkasov on 14.01.2024.
//

import Cocoa

protocol HierarchyViewInput {
	func display(_ snapshot: HierarchySnapshot)
}

class HierarchyViewController: NSViewController {

	// MARK: - UI-Properties

	lazy var scrollview: NSScrollView = {
		let view = NSScrollView()
		view.borderType = .noBorder
		view.hasHorizontalScroller = false
		view.autohidesScrollers = true
		view.hasVerticalScroller = true
		return view
	}()

	lazy var table: NSOutlineView = {
		let view = NSOutlineView()
		view.style = .inset
		view.rowSizeStyle = .default
		view.floatsGroupRows = false
		view.allowsMultipleSelection = true
		view.allowsColumnResizing = false
		view.usesAlternatingRowBackgroundColors = true
		view.usesAutomaticRowHeights = false
		return view
	}()

	// MARK: - DI

	var adapter: HierarchyTableAdapter?

	// MARK: - View life-cycle

	override func viewDidLoad() {
		super.viewDidLoad()

		self.adapter = HierarchyTableAdapter(table: table)

		configureUserInterface()
		configureConstraints()
	}
}

// MARK: - HierarchyViewInput
extension HierarchyViewController: HierarchyViewInput {

	func display(_ snapshot: HierarchySnapshot) {
		adapter?.apply(snapshot)
	}
}

// MARK: - Helpers
private extension HierarchyViewController {

	func configureUserInterface() {

		table.headerView = nil
		table.autoresizesOutlineColumn = false
		table.columnAutoresizingStyle = .reverseSequentialColumnAutoresizingStyle
		table.allowsColumnResizing = true
		table.allowsMultipleSelection = true

		scrollview.documentView = table
		scrollview.hasVerticalScroller = false

		table.frame = scrollview.bounds

		let column1 = NSTableColumn(identifier: .init(rawValue: "text"))
		column1.title = "Text"
		table.addTableColumn(column1)
	}

	func configureConstraints() {
		[scrollview].forEach {
			view.addSubview($0)
			$0.translatesAutoresizingMaskIntoConstraints = false
		}

		NSLayoutConstraint.activate(
			[
				scrollview.leadingAnchor.constraint(equalTo: view.leadingAnchor),
				scrollview.trailingAnchor.constraint(equalTo: view.trailingAnchor),
				scrollview.topAnchor.constraint(equalTo: view.topAnchor),
				scrollview.bottomAnchor.constraint(equalTo: view.bottomAnchor)
			]
		)
	}
}
