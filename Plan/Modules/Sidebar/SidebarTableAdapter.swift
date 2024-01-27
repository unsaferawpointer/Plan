//
//  SidebarTableAdapter.swift
//  Plan
//
//  Created by Anton Cherkasov on 27.01.2024.
//

import Cocoa

final class SidebarTableAdapter: NSObject {

	weak var table: NSOutlineView?

	var selection: ((SidebarItem) -> Void)?

	// MARK: - Data

	private var items: [SidebarItem] = 
	[
		.focus,
		.backlog,
		.favorites,
		.projects
	]

	// MARK: - Initialization

	init(table: NSOutlineView) {
		super.init()

		self.table = table

		table.delegate = self
		table.dataSource = self
	}
}

// MARK: - NSOutlineViewDataSource
extension SidebarTableAdapter: NSOutlineViewDataSource {

	func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
		assert(item == nil, "Item should be nil")
		return items[index]
	}

	func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
		assert(item == nil, "Item should be nil")
		return items.count
	}

	func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
		return false
	}
}

// MARK: - NSOutlineViewDelegate
extension SidebarTableAdapter: NSOutlineViewDelegate {

	func outlineViewSelectionDidChange(_ notification: Notification) {
		guard let row = table?.selectedRow, row != -1 else {
			return
		}
		let item = items[row]
		selection?(item)
	}

	func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
		guard let item = item as? SidebarItem else {
			return nil
		}

		let id = NSUserInterfaceItemIdentifier(LabelView.userIdentifier)
		var view = table?.makeView(withIdentifier: id, owner: self) as? LabelView2
		if view == nil {
			view = LabelView2()
			view?.identifier = id
		}

		let configuration = LabelConfig(title: item.title, iconName: item.icon, iconColor: item.color)
		view?.configure(configuration)

		return view
	}

	func outlineView(_ outlineView: NSOutlineView, tintConfigurationForItem item: Any) -> NSTintConfiguration? {
		guard let item = item as? SidebarItem else {
			return nil
		}

		guard let color = item.color else {
			return .default
		}

		return .init(preferredColor: color)
	}

}
