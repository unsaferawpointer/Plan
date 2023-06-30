//
//  Primary.ViewController.swift
//  Plan
//
//  Created by Anton Cherkasov on 04.06.2023.
//

import Cocoa

/// View of the Primary unit
protocol PrimaryView: AnyObject {

	/// Display view-model
	func display(_ sections: [Primary.SectionModel])
}

extension Primary {

	/// Sidebar view-controller
	final class ViewController: NSViewController {

		var output: ViewControllerOutput?

		var sections: [SectionModel] = []

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
			view.rowSizeStyle = .default
			view.floatsGroupRows = false
			view.allowsMultipleSelection = false
			view.allowsColumnResizing = false
			view.usesAlternatingRowBackgroundColors = false
			view.usesAutomaticRowHeights = false
			return view
		}()

		lazy var contextMenu: NSMenu = {
			let menu = NSMenu()
			menu.delegate = self
			return menu
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
		}

		@available(*, unavailable, message: "Use init()")
		required init?(coder: NSCoder) {
			fatalError("init(coder:) has not been implemented")
		}

		// MARK: - Life-cycle

		override func loadView() {
			self.view = scrollview
		}

		override func viewDidLoad() {
			super.viewDidLoad()
			output?.viewControllerDidChangeState(.viewDidLoad)
		}
	}
}

// MARK: - PrimaryView
extension Primary.ViewController: PrimaryView {

	func display(_ sections: [Primary.SectionModel]) {
		self.sections = sections
		table.reloadData()
		table.expandItem(nil, expandChildren: true)
	}
}

// MARK: - Helpers
private extension Primary.ViewController {

	func configureUserInterface() {

		scrollview.documentView = table

		let column = NSTableColumn(identifier: .init("main"))
		column.resizingMask = [.autoresizingMask, .userResizingMask]
		table.addTableColumn(column)
		table.headerView = nil

		table.menu = contextMenu

		table.dataSource = self
		table.delegate = self
	}
}

// MARK: - NSOutlineViewDataSource
extension Primary.ViewController: NSOutlineViewDataSource {

	func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
		guard let section = item as? Primary.SectionModel else {
			return sections[index]
		}
		return section.items[index]
	}

	func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
		guard let section = item as? Primary.SectionModel else {
			return sections.count
		}
		return section.items.count
	}

	func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
		guard let section = item as? Primary.SectionModel else {
			return false
		}
		return section.items.count > 0
	}
}

// MARK: - NSOutlineViewDelegate
extension Primary.ViewController: NSOutlineViewDelegate {

	func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
		if let section = item as? Primary.SectionModel {
			return makeFieldIfNeeded(outlineView, configuration: section.content)
		} else if let item = item as? Primary.ItemModel {
			return makeFieldIfNeeded(outlineView, configuration: item.content)
		}
		return nil
	}

	func outlineView(_ outlineView: NSOutlineView, isGroupItem item: Any) -> Bool {
		guard item is Primary.SectionModel else {
			return false
		}
		return true
	}

	func outlineView(_ outlineView: NSOutlineView, shouldSelectItem item: Any) -> Bool {
		guard item is Primary.SectionModel else {
			return true
		}
		return false
	}

	func outlineView(_ outlineView: NSOutlineView, tintConfigurationForItem item: Any) -> NSTintConfiguration? {
		guard let item = item as? Primary.ItemModel, let color = item.tintColor else {
			return nil
		}
		return .init(preferredColor: color)
	}

}

extension Primary.ViewController {

	func configureField<T: FieldConfiguration, Field: ConfigurableField>(configuration: T, at row: Int) where T.Field == Field {
		let field = table.view(atColumn: 0, row: row, makeIfNecessary: false) as? Field
		field?.configure(configuration)
	}

	func makeFieldIfNeeded<T: FieldConfiguration, Field: ConfigurableField>(_ table: NSOutlineView, configuration: T) -> NSView? where T.Field == Field {
		let id = NSUserInterfaceItemIdentifier(Field.userIdentifier)
		var field = table.makeView(withIdentifier: id, owner: self) as? Field
		if field == nil {
			field = Field(configuration)
			field?.identifier = id
		}
		field?.configure(configuration)
		return field
	}
}

extension Primary.ViewController: NSMenuDelegate {

	func menuNeedsUpdate(_ menu: NSMenu) {

		menu.removeAllItems()

		let clickedRow = table.clickedRow
		let itemModel = table.item(atRow: clickedRow) as? Primary.ItemModel
		guard clickedRow != -1, let itemModel else {
			return
		}

		itemModel.menu.forEach {
			menu.addItem(MenuItemWrapper(model: $0))
		}
	}
}
