//
//  SidebarViewController.swift
//  Plan
//
//  Created by Anton Cherkasov on 27.01.2024.
//

import Cocoa

protocol SidebarViewOutput: ViewOutput, AnyObject {
	func selectionDidChange(_ newValue: SidebarItem)
	func labelDidChangeText(_ newText: String, forItem withId: UUID)
}

protocol SidebarView: AnyObject {
	func display(
		staticContent: [SidebarItem],
		sectionTitle: String,
		dynamicContent: [SidebarItem]
	)
	func selectItem(_ id: Route)
	func clickedItem() -> Route?
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

	init(_ menu: NSMenu, configure: (SidebarViewController) -> Void) {
		super.init(nibName: nil, bundle: nil)
		configure(self)
		self.adapter = SidebarTableAdapter(table: table)
		adapter?.output = output
		table.menu = menu
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - View life-cycle

	override func loadView() {
		self.view = NSView()
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		configureUserInterface()
		configureConstraints()

		output?.viewDidChange(state: .didLoad)
	}
}

// MARK: - SidebarView
extension SidebarViewController: SidebarView {

	func display(
		staticContent: [SidebarItem],
		sectionTitle: String,
		dynamicContent: [SidebarItem]
	) {
		adapter?.display(
			staticContent: staticContent,
			sectionTitle: sectionTitle,
			dynamicContent: dynamicContent
		)
	}

	func selectItem(_ id: Route) {
		adapter?.selectItem(id)
	}

	func clickedItem() -> Route? {
		adapter?.clickedItem()
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
		scrollview.pin(to: view)
	}
}
