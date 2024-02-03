//
//  TodosViewController.swift
//  Plan
//
//  Created by Anton Cherkasov on 27.01.2024.
//

import Cocoa

protocol TodosViewOutput: AnyObject, ViewOutput { 
	func toolbarNewTodoButtonHasBeenClicked()
	func performModification(_ modification: TodoModification, forTodos ids: [UUID])
	func selectionDidChange(_ newValue: [UUID])
	func delete(_ ids: [UUID])
}

protocol TodosView: AnyObject {
	func display(_ items: [TodoModel])
}

final class TodosViewController: NSViewController {

	var output: TodosViewOutput?

	var adapter: TodosTableAdapter?

	// MARK: - UI-Properties

	lazy var scrollview: NSScrollView = {
		let view = NSScrollView()
		view.borderType = .noBorder
		view.hasHorizontalScroller = false
		view.autohidesScrollers = true
		view.hasVerticalScroller = true
		view.automaticallyAdjustsContentInsets = true
		view.drawsBackground = true
		return view
	}()

	lazy var table: NSTableView = {
		let view = NSTableView()
		view.style = .inset
		view.rowSizeStyle = .large
		view.floatsGroupRows = false
		view.allowsMultipleSelection = true
		view.allowsColumnResizing = false
		view.usesAlternatingRowBackgroundColors = false
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

	override func loadView() {
		self.view = NSView()
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		configureUserInterface()
		configureConstraints()
		configureAdapter()
		configureSubscriptions()

		output?.viewDidChange(state: .didLoad)
	}
}

// MARK: - TodosView
extension TodosViewController: TodosView {

	func display(_ items: [TodoModel]) {
		adapter?.apply(items)
	}
}

// MARK: - MenuSupportable
extension TodosViewController: MenuSupportable {

	func createNew(_ sender: NSMenuItem) {
		// TODO: - Handle action
	}

	func toggleBookmark(_ sender: NSMenuItem) {
		// TODO: - Handle action
	}

	func toggleCompleted(_ sender: NSMenuItem) {
		// TODO: - Handle action
	}

	func delete(_ sender: NSMenuItem) {
		// TODO: - Handle action
	}
}

// MARK: - NSMenuItemValidation
extension TodosViewController: NSMenuItemValidation {

	func validateMenuItem(_ menuItem: NSMenuItem) -> Bool {
		guard let identifier = menuItem.identifier, let adapter else {
			return false
		}

		let state = adapter.menuItemState(for: identifier)
		menuItem.state = state

		return adapter.validateMenuItem(identifier)
	}
}

// MARK: - Helpers
private extension TodosViewController {

	func configureSubscriptions() {
		NotificationCenter.default.addObserver(
			forName: .toolbarNewTodoButtonHasBeenClicked,
			object: nil,
			queue: .main) { [weak self] _ in
				self?.output?.toolbarNewTodoButtonHasBeenClicked()
			}
	}

	func configureAdapter() {
		self.adapter = TodosTableAdapter(table: table)
		self.adapter?.output = output
	}

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
