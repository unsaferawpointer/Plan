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

	// MARK: - Internal state

	private var isEditing: Bool = false

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

	func display(staticContent: [SidebarItem]) {
		self.items = staticContent

		isEditing = true
		table?.reloadData()
		isEditing = false
	}

	func display(sectionTitle: String, dynamicContent: [SidebarItem]) {
		self.section.title = sectionTitle
		self.section.items = dynamicContent

		isEditing = true
		table?.reloadItem(section, reloadChildren: true)
		table?.expandItem(section, expandChildren: true)
		isEditing = false
	}

	func selectItem(_ id: Route?) {
		guard let id else {
			return
		}

		isEditing = true

		if let index = items.firstIndex(where: { $0.id == id }) {
			table?.selectRowIndexes(.init(integer: index), byExtendingSelection: false)
		}

		if let index = section.items.firstIndex(where: { $0.id == id }) {
			table?.selectRowIndexes(.init(integer: index + items.count + 1), byExtendingSelection: false)
		}
		isEditing = false
	}

	func selectedItem() -> Route? {
		guard
			let row = table?.selectedRow, row != -1,
			let item = table?.item(atRow: row) as? SidebarItem,
			!isEditing
		else {
			return nil
		}
		return item.id
	}

	func clickedItem() -> Route? {
		guard 
			let row = table?.effectiveSelection().first,
			let item = table?.item(atRow: row) as? SidebarItem
		else {
			return nil
		}
		return item.id
	}

	func scrollTo(id: Route) {
		if let index = items.firstIndex(where: { $0.id == id }) {
			NSAnimationContext.runAnimationGroup { context in
				context.allowsImplicitAnimation = true
				table?.scrollRowToVisible(index)
			}
		}

		if let index = section.items.firstIndex(where: { $0.id == id }) {
			NSAnimationContext.runAnimationGroup { context in
				context.allowsImplicitAnimation = true
				table?.scrollRowToVisible(index + items.count + 1)
			}
		}
	}

	func focusOn(id: Route) {
		if
			let index = items.firstIndex(where: { $0.id == id }),
			let view = table?.view(atColumn: 0, row: index, makeIfNecessary: false) as? LabelView
		{
			view.focusOn()
		}

		if 
			let index = section.items.firstIndex(where: { $0.id == id }),
			let view = table?.view(atColumn: 0, row: index + items.count + 1, makeIfNecessary: false) as? LabelView
		{
			view.focusOn()
		}
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
		guard let row = table?.selectedRow, row != -1, !isEditing else {
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
