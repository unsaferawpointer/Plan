//
//  ContentTableAdapter.swift
//  Plan
//
//  Created by Anton Cherkasov on 20.01.2024.
//

import Cocoa

final class HierarchyTableAdapter: NSObject {

	weak var table: NSOutlineView?

	private var animator = HierarchyAnimator()

	// MARK: - Data

	private var snapshot: HierarchySnapshot = .init()

	private var cache: [UUID: HierarchyListItem] = [:]

	// MARK: - Initialization

	init(table: NSOutlineView) {
		self.table = table
		super.init()

		table.delegate = self
		table.dataSource = self
	}
}

// MARK: - Public interface
extension HierarchyTableAdapter {

	func apply(_ new: HierarchySnapshot) {
		let old = snapshot

		let intersection = old.identifiers.intersection(new.identifiers)

		for id in intersection {
			let item = cache[unsafe: id]
			let model = new.model(with: id)
			guard let row = table?.row(forItem: item), row != -1 else {
				continue
			}
			configureRow(with: model, at: row)
		}

		table?.beginUpdates()

		let (deleted, inserted) = animator.calculate(old: snapshot, new: new)
		for id in deleted {
			cache[id] = nil
		}
		for id in inserted {
			cache[id] = HierarchyListItem(uuid: id)
		}

		self.snapshot = new
		animator.calculate(old: old, new: new) { [weak self] animation in
			guard let self else {
				return
			}
			switch animation {
			case .remove(let offset, let parent):
				let item = cache[parent]
				let rows = IndexSet(integer: offset)
				table?.removeItems(
					at: rows,
					inParent: item,
					withAnimation: [.effectFade, .slideLeft]
				)
			case .insert(let offset, let parent):
				let destination = cache[parent]
				let rows = IndexSet(integer: offset)
				table?.insertItems(
					at: rows,
					inParent: destination,
					withAnimation: [.effectFade, .slideRight]
				)
			case .reload(let id):
				guard let item = cache[id] else {
					return
				}
				table?.reloadItem(item)
			}
		}
		table?.endUpdates()
	}
}

// MARK: - NSOutlineViewDataSource
extension HierarchyTableAdapter: NSOutlineViewDataSource {

	func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
		guard
			let item = item as? HierarchyListItem
		else {
			let id = snapshot.rootItem(at: index).id
			return cache[unsafe: id]
		}
		let id = snapshot.childOfItem(item.uuid, at: index).id
		return cache[unsafe: id]
	}

	func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
		guard
			let item = item as? HierarchyListItem
		else {
			return snapshot.numberOfRootItems()
		}
		return snapshot.numberOfChildren(ofItem: item.uuid)
	}

	func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
		guard let item = item as? HierarchyListItem else {
			return false
		}
		return snapshot.numberOfChildren(ofItem: item.uuid) > 0
	}
}

// MARK: - NSOutlineViewDelegate
extension HierarchyTableAdapter: NSOutlineViewDelegate {

	func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
		guard let item = item as? HierarchyListItem else {
			return nil
		}

		let model = snapshot.model(with: item.uuid)

		let id = NSUserInterfaceItemIdentifier(LabelView.userIdentifier)
		var view = table?.makeView(withIdentifier: id, owner: self) as? LabelView
		if view == nil {
			view = LabelView()
			view?.identifier = id
		}

		let configuration = LabelConfiguration(title: model.text) { _ in
			// TODO: - Handle action
		}
		view?.configure(configuration)

		return view
	}

}

// MARK: - Helpers
private extension HierarchyTableAdapter {

	func configureRow(with model: HierarchyTodoModel, at row: Int) {
		let view = table?.view(atColumn: 0, row: row, makeIfNecessary: false) as? LabelView
		let configuration = LabelConfiguration(title: model.text) { _ in
			// TODO: - Handle action
		}
		view?.configure(configuration)
	}
}
