//
//  SidebarViewController.swift
//  Plan
//
//  Created by Anton Cherkasov on 27.01.2024.
//

import Cocoa

protocol SidebarViewOutput {
	func selectionDidChange(_ newValue: SidebarItem)
}

class SidebarViewController: NSViewController {

	var output: SidebarViewOutput?

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

	lazy var table: NSOutlineView = {
		let view = NSOutlineView()
		view.style = .sourceList
		view.rowSizeStyle = .default
		view.floatsGroupRows = false
		view.allowsMultipleSelection = false
		view.allowsColumnResizing = false
		view.usesAlternatingRowBackgroundColors = false
		view.usesAutomaticRowHeights = false
		return view
	}()

	// MARK: - DI

	var adapter: SidebarTableAdapter?

	// MARK: - Initialization

	init(configure: (SidebarViewController) -> Void) {
		super.init(nibName: nil, bundle: nil)
		configure(self)
		self.adapter = SidebarTableAdapter(table: table)
		adapter?.selection = { [weak self] newValue in
			guard let self else {
				return
			}
			self.output?.selectionDidChange(newValue)
		}
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - View life-cycle

	override func loadView() {
		super.loadView()
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		configureUserInterface()
		configureConstraints()
	}
}

// MARK: - Helpers
private extension SidebarViewController {

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
