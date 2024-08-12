//
//  PlanViewController.swift
//  Hierarchy
//
//  Created by Anton Cherkasov on 29.09.2023.
//

import Cocoa

protocol PlanViewOutput {

	func viewDidLoad()

	func deleteItems()

	func createNew()

	func setState(_ flag: Bool)

	func setBookmark(_ flag: Bool)

	func setEstimation(_ value: Int)

	func setIcon(_ value: String?)

	func canUndo() -> Bool

	func canRedo() -> Bool

	func redo()

	func undo()

	func fold()

	func unfold()

	func paste()
}

protocol HierarchyView: AnyObject {

	func display(_ model: PlanModel)

	func setConfiguration(_ configuration: DropConfiguration)

	func scroll(to id: UUID)

	func select(_ id: UUID)

	func expand(_ ids: [UUID])

	func collapse(_ ids: [UUID])

	func focus(on id: UUID)

	var selection: [UUID] { get }
}

class PlanViewController: NSViewController {

	// MARK: - DI

	var adapter: HierarchyTableAdapter?

	var output: (PlanViewOutput & HierarchyDropDelegate & ListItemViewOutput)?

	// MARK: - UI-Properties

	lazy var scrollview = NSScrollView.plain

	lazy var table = NSOutlineView.inset

	lazy var placeholderView = PlaceholderView(frame: .zero)

	lazy var bottomBar = BottomBar(frame: .zero)

	// MARK: - Initialization

	init(configure: (PlanViewController) -> Void) {
		super.init(nibName: nil, bundle: nil)
		configure(self)
		self.adapter = HierarchyTableAdapter(table: table)
	}
	
	@available(*, unavailable, message: "Use init(storage:)")
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - View life-cycle

	override func loadView() {
		self.view = NSView()
		configureUserInterface()
		configureConstraints()
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		output?.viewDidLoad()
	}

	override func viewWillAppear() {
		super.viewWillAppear()
		table.sizeLastColumnToFit()
		adapter?.expand([])
	}
}

// MARK: - HierarchyView
extension PlanViewController: HierarchyView {

	func display(_ model: PlanModel) {

		switch model {
		case .placeholder(let title, let subtitle):
			placeholderView.isHidden = false
			placeholderView.subtitle = subtitle
			placeholderView.title = title
			adapter?.apply(.init())
			bottomBar.model = .init()
		case .regular(let snapshot, let status):
			placeholderView.isHidden = true
			adapter?.apply(snapshot)
			bottomBar.model = status
		}
	}

	func setConfiguration(_ configuration: DropConfiguration) {
		adapter?.dropConfiguration = configuration
		adapter?.delegate = output
	}

	func scroll(to id: UUID) {
		adapter?.scroll(to: id)
	}

	func select(_ id: UUID) {
		adapter?.select(id)
	}

	func expand(_ ids: [UUID]) {
		adapter?.expand(ids)
	}

	func collapse(_ ids: [UUID]) {
		adapter?.collapse(ids)
	}

	func focus(on id: UUID) {
		adapter?.focus(on: id)
	}

	var selection: [UUID] {
		return table.selectedIdentifiers()
	}
}

// MARK: - Helpers
private extension PlanViewController {

	func configureUserInterface() {

		table.headerView = nil
		table.autoresizesOutlineColumn = false
		table.allowsMultipleSelection = true
		table.frame = scrollview.bounds

		scrollview.documentView = table
		scrollview.hasVerticalScroller = false
		scrollview.automaticallyAdjustsContentInsets = true

		let identifier = NSUserInterfaceItemIdentifier("main")
		let column = NSTableColumn(identifier: identifier)
		table.addTableColumn(column)

		table.menu = makeContextMenu()
	}

	func configureConstraints() {
		[scrollview, placeholderView, bottomBar].forEach {
			view.addSubview($0)
			$0.translatesAutoresizingMaskIntoConstraints = false
		}

		NSLayoutConstraint.activate(
			[
				scrollview.leadingAnchor.constraint(equalTo: view.leadingAnchor),
				scrollview.trailingAnchor.constraint(equalTo: view.trailingAnchor),
				scrollview.topAnchor.constraint(equalTo: view.topAnchor),
				scrollview.bottomAnchor.constraint(equalTo: bottomBar.topAnchor),

				placeholderView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
				placeholderView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
				placeholderView.topAnchor.constraint(equalTo: view.topAnchor),
				placeholderView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

				bottomBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
				bottomBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
				bottomBar.bottomAnchor.constraint(equalTo: view.bottomAnchor)
			]
		)
	}

	func makeContextMenu() -> NSMenu {
		return MenuBuilder.makeMenu(
			withTitle: "Context", 
			for: 
				[
					.new,
					.separator,
					.favorite,
					.completed,
					.separator,
					.setEstimation,
					.setIcon,
					.separator,
					.delete
				]
		)
	}
}

// MARK: - NSMenuItemValidation
extension PlanViewController: NSMenuItemValidation {

	func validateMenuItem(_ menuItem: NSMenuItem) -> Bool {
		guard let identifier = menuItem.identifier, let adapter else {
			return false
		}

		switch identifier {
		case .redoMenuItem:
			return output?.canRedo() ?? false
		case .undoMenuItem:
			return output?.canUndo() ?? false
		case .newMenuItem,
			 .setEstimationMenuItem,
			 .setIconMenuItem,
			 .iconsGroupMenuItem,
			 .pasteMenuItem:
			return true
		case .foldMenuItem, .unfoldMenuItem:
			return !adapter.selection.isEmpty
		default:
			break
		}
		let state = adapter.menuItemState(for: identifier.rawValue)
		menuItem.state = state

		return adapter.validateMenuItem(identifier.rawValue)
	}
}

// MARK: - MenuSupportable
extension PlanViewController: MenuSupportable {

	@IBAction
	func createNew(_ sender: NSMenuItem) {
		output?.createNew()
	}

	@IBAction
	func delete(_ sender: NSMenuItem) {
		output?.deleteItems()
	}

	@IBAction
	func toggleBookmark(_ sender: NSMenuItem) {
		let enabled = sender.state == .on
		output?.setBookmark(!enabled)
	}

	@IBAction
	func toggleCompleted(_ sender: NSMenuItem) {
		let enabled = sender.state == .on
		output?.setState(!enabled)
	}

	@IBAction
	func setEstimation(_ sender: NSMenuItem) {
		let number = sender.tag
		output?.setEstimation(number)
	}

	@IBAction
	func setIcon(_ sender: NSMenuItem) {
		let iconName = sender.representedObject as? String
		output?.setIcon(iconName)
	}

	@IBAction
	func undo(_ sender: NSMenuItem) {
		output?.undo()
	}

	@IBAction
	func redo(_ sender: NSMenuItem) {
		output?.redo()
	}

	@IBAction
	func fold(_ sender: NSMenuItem) {
		output?.fold()
	}

	@IBAction
	func unfold(_ sender: NSMenuItem) {
		output?.unfold()
	}

	@IBAction
	func paste(_ sender: NSMenuItem) {
		output?.paste()
	}
}
