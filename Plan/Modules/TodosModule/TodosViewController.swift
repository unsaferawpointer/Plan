//
//  TodosViewController.swift
//  Plan
//
//  Created by Anton Cherkasov on 27.01.2024.
//

import Cocoa

protocol TodosViewOutput: AnyObject, ViewOutput { 
	func createTodo()
	func performModification(_ modification: TodoModification, forTodos ids: [UUID])
	func selectionDidChange(_ newValue: [UUID])
	func setGrouping(_ grouping: TodosGrouping)
	func delete(_ ids: [UUID])
}

protocol TodosView: AnyObject {
	func display(_ state: TodosViewState)
	var selection: [UUID] { get }
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
		view.rowSizeStyle = .medium
		view.rowHeight = 42
		view.floatsGroupRows = false
		view.allowsMultipleSelection = true
		view.allowsColumnResizing = false
		view.usesAlternatingRowBackgroundColors = false
		view.usesAutomaticRowHeights = false
		view.floatsGroupRows = false
		view.intercellSpacing = .init(width: 0, height: 4)
		return view
	}()

	lazy var placeholderView = PlaceholderView(frame: .zero)

	// MARK: - Initialization

	init(_ menu: NSMenu, configure: (TodosViewController) -> Void) {
		super.init(nibName: nil, bundle: nil)
		table.menu = menu
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

	override func viewWillAppear() {
		super.viewWillAppear()
		table.sizeLastColumnToFit()
	}
}

// MARK: - TodosView
extension TodosViewController: TodosView {

	var selection: [UUID] {
		return adapter?.selection ?? []
	}

	func display(_ state: TodosViewState) {
		switch state {
		case .placeholder(let title, let subtitle, let image):
			placeholderView.isHidden = false
			placeholderView.title = title
			placeholderView.subtitle = subtitle
			placeholderView.iconView.image = NSImage(named: image)
			table.usesAlternatingRowBackgroundColors = false
			adapter?.apply([])
		case .content(let items):
			placeholderView.isHidden = true
			table.usesAlternatingRowBackgroundColors = true
			adapter?.apply(items)
		}
	}
}

// MARK: - MenuSupportable
extension TodosViewController: MenuSupportable {

	func createNew(_ sender: NSMenuItem) {
		output?.createTodo()
	}
}

// MARK: - Helpers
private extension TodosViewController {

	func configureSubscriptions() {
		NotificationCenter.default.addObserver(
			forName: .toolbarNewTodoButtonHasBeenClicked,
			object: nil,
			queue: .main) { [weak self] _ in
				self?.output?.createTodo()
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
		table.allowsColumnResizing = true
		table.columnAutoresizingStyle = .firstColumnOnlyAutoresizingStyle

		let column = NSTableColumn(identifier: .init(rawValue: "main"))
		column.resizingMask = .autoresizingMask

		table.addTableColumn(column)
	}

	func configureConstraints() {
		scrollview.pin(to: view)
		placeholderView.pin(to: view)
	}
}
