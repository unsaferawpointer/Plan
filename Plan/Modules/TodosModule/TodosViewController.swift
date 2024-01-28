//
//  TodosViewController.swift
//  Plan
//
//  Created by Anton Cherkasov on 27.01.2024.
//

import Cocoa

final class TodosViewController: NSViewController {

	// MARK: - UI-Properties

	lazy var scrollview: NSScrollView = {
		let view = NSScrollView()
		view.borderType = .noBorder
		view.hasHorizontalScroller = false
		view.autohidesScrollers = true
		view.hasVerticalScroller = true
		view.automaticallyAdjustsContentInsets = false
		view.automaticallyAdjustsContentInsets = true
		view.drawsBackground = false
		return view
	}()

	lazy var table: NSTableView = {
		let view = NSTableView()
		view.style = .fullWidth
		view.rowSizeStyle = .default
		view.floatsGroupRows = false
		view.allowsMultipleSelection = false
		view.allowsColumnResizing = false
		view.usesAlternatingRowBackgroundColors = true
		view.usesAutomaticRowHeights = false
		return view
	}()

	// MARK: - Initialization

	init(configure: (TodosViewController) -> Void) {
		super.init(nibName: nil, bundle: nil)
		configure(self)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - View life-cycle

	override func viewDidLoad() {
		super.viewDidLoad()

		configureUserInterface()
		configureConstraints()
	}
}

// MARK: - Helpers
private extension TodosViewController {

	func configureUserInterface() {

		table.headerView = nil
		scrollview.documentView = table

		table.frame = scrollview.bounds

		let column1 = NSTableColumn(identifier: .init(rawValue: "main"))
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
