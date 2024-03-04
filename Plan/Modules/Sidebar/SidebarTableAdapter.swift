//
//  SidebarTableAdapter.swift
//  Plan
//
//  Created by Anton Cherkasov on 27.01.2024.
//

import Cocoa

final class SidebarTableAdapter: NSObject {

	weak var table: NSOutlineView?

	weak var output: SidebarViewOutput?

	// MARK: - Data

	private var items: [SidebarItem] = []

	private var section: SidebarSection = .init(title: "", items: [])

	// MARK: - Initialization

	init(table: NSOutlineView) {
		super.init()

		self.table = table

		table.delegate = self
		table.dataSource = self
	}
}

// MARK: - Public interface
extension SidebarTableAdapter {

	func display(staticContent: [SidebarItem], sectionTitle: String, dynamicContent: [SidebarItem]) {

		self.items = staticContent
		self.section.title = sectionTitle
		self.section.items = dynamicContent

		table?.reloadData()
		table?.expandItem(section, expandChildren: true)
	}

	func selectItem(_ id: Route) {

		if let index = items.firstIndex(where: { $0.id == id }) {
			table?.selectRowIndexes(.init(integer: index), byExtendingSelection: false)
		}

		if let index = section.items.firstIndex(where: { $0.id == id }) {
			table?.selectRowIndexes(.init(integer: index), byExtendingSelection: false)
		}
	}

	func clickedItem() -> Route? {
		guard 
			let clickedRow = table?.clickedRow, clickedRow != -1,
			let item = table?.item(atRow: clickedRow) as? SidebarItem
		else {
			return nil
		}
		return item.id
	}
}

// MARK: - NSOutlineViewDataSource
extension SidebarTableAdapter: NSOutlineViewDataSource {

	func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
		guard let section = item as? SidebarSection else {
			switch index {
			case 0..<items.count:
				return items[index]
			default:
				return section
			}
		}
		return section.items[index]
	}

	func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
		guard let section = item as? SidebarSection else {
			return items.count + 1
		}
		return section.items.count
	}

	func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
		return item is SidebarSection
	}
}

// MARK: - NSOutlineViewDelegate
extension SidebarTableAdapter: NSOutlineViewDelegate {

	func outlineViewSelectionDidChange(_ notification: Notification) {
		guard let row = table?.selectedRow, row != -1 else {
			return
		}

		switch row {
		case 0..<items.count:
			let item = items[row]
			output?.selectionDidChange(item)
		default:
			if let item = table?.item(atRow: row) as? SidebarItem {
				output?.selectionDidChange(item)
			}
		}
	}

	func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
		if let section = item as? SidebarSection {

			let header = NSTextField(string: section.title)
			header.isEditable = false
			header.isBordered = false
			header.drawsBackground = false
			return header
		}

		let id = NSUserInterfaceItemIdentifier(LabelView.userIdentifier)

		if let item = item as? SidebarItem {
			var view = table?.makeView(withIdentifier: id, owner: self) as? LabelView
			if view == nil {
				view = LabelView()
				view?.identifier = id
			}

			let configuration = LabelConfig(title: item.title, iconName: item.icon, iconColor: nil, isEditable: item.isEditable)
			view?.configure(configuration)

			switch item.id {
			case .list(let id):
				view?.labelDidChangeText = { [weak self] newValue in
					self?.output?.labelDidChangeText(newValue, forItem: id)
				}
			default:
				view?.labelDidChangeText = nil
			}

			return view
		}

		return nil
	}

	func outlineView(_ outlineView: NSOutlineView, isGroupItem item: Any) -> Bool {
		return item is SidebarSection
	}

	func outlineView(_ outlineView: NSOutlineView, tintConfigurationForItem item: Any) -> NSTintConfiguration? {
		guard let item = item as? SidebarItem else {
			return .monochrome
		}
		return item.tintColor.configuration
	}

	func outlineView(_ outlineView: NSOutlineView, shouldSelectItem item: Any) -> Bool {
		guard item is SidebarSection else {
			return true
		}
		return false
	}

}
