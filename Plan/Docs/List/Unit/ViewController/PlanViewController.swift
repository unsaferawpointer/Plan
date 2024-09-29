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

	func setIcon(_ value: IconName?)

	func canUndo() -> Bool

	func canRedo() -> Bool

	func redo()

	func undo()

	func fold()

	func unfold()

	func paste()

	func canPaste() -> Bool

	func copy()

	func cut()
}

protocol PlanView: AnyObject {

	func display(_ model: PlanModel)

	func setConfiguration(_ configuration: DropConfiguration)

	func setConfiguration(_ columns: [any TableColumn<HierarchyModel>])

	func scroll(to id: UUID)

	func select(_ id: UUID)

	func expand(_ ids: [UUID])

	func expandAll()

	func collapse(_ ids: [UUID])

	func focus(on id: UUID)

	var selection: [UUID] { get }
}

class PlanViewController: NSViewController {

	// MARK: - DI

	private(set) var adapter: HierarchyTableAdapter?

	var output: (PlanViewOutput & HierarchyDropDelegate)?

	// MARK: - UI-Properties

	lazy var scrollview = NSScrollView.plain

	lazy var table = NSOutlineView.inset

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

// MARK: - PlanView
extension PlanViewController: PlanView {

	func display(_ model: PlanModel) {
		adapter?.apply(model.snapshot)
		bottomBar.model = model.bottomBar
	}

	func setConfiguration(_ columns: [any TableColumn<HierarchyModel>]) {
		for model in columns {
			let column = NSTableColumn(identifier: .init(rawValue: model.identifier))
			column.title = model.title
			column.resizingMask = model.options.isRequired ? .autoresizingMask : .userResizingMask
			column.isHidden = model.options.isHidden
			if let minWidth = model.options.minWidth {
				column.minWidth = minWidth
			}
			if let maxWidth = model.options.maxWidth {
				column.maxWidth = maxWidth
			}
			table.addTableColumn(column)
		}
		adapter?.configure(columns: columns)
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

	func expandAll() {
		adapter?.expand(nil)
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

		table.autoresizesOutlineColumn = false
		table.allowsMultipleSelection = true
		table.frame = scrollview.bounds

		scrollview.documentView = table
		scrollview.hasVerticalScroller = false
		scrollview.automaticallyAdjustsContentInsets = true

		table.headerView?.setAccessibilityRole(.unknown)

		table.allowsColumnResizing = true
		table.columnAutoresizingStyle = .firstColumnOnlyAutoresizingStyle

		table.menu = makeContextMenu()
	}

	func configureConstraints() {
		[scrollview, bottomBar].forEach {
			view.addSubview($0)
			$0.translatesAutoresizingMaskIntoConstraints = false
		}

		NSLayoutConstraint.activate(
			[
				scrollview.leadingAnchor.constraint(equalTo: view.leadingAnchor),
				scrollview.trailingAnchor.constraint(equalTo: view.trailingAnchor),
				scrollview.topAnchor.constraint(equalTo: view.topAnchor),
				scrollview.bottomAnchor.constraint(equalTo: bottomBar.topAnchor),

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
					.newItem,
					.separator,
					.favorite,
					.completed,
					.separator,
					.cut,
					.copy,
					.paste,
					.separator,
					.setEstimation,
					.setIcon,
					.separator,
					.delete
				]
		)
	}
}

extension String {
	static let dateCreatedColumn = "date_created_column"
}
