//
//  HierarchyViewController.swift
//  Plan
//
//  Created by Anton Cherkasov on 29.09.2023.
//

import Cocoa

protocol PlanViewOutput: UndoManagerSupportable, PasteboardSupportable {

	func viewDidLoad()

	func deleteItems()

	func createNew()

	func setState(_ flag: Bool)

	func setBookmark(_ flag: Bool)

	func setEstimation(_ value: Int)

	func setPriority(_ value: Int)

	func setIcon(_ value: IconName?)

	func setColor(_ value: Color?)

	func fold()

	func unfold()
}

protocol PlanView: AnyObject, OutlineSupportable {

	func display(_ model: HierarchyUnitModel)

	func setConfiguration(_ configuration: DropConfiguration)

	func setConfiguration(_ columns: [any TableColumn<HierarchyModel>])
}

class HierarchyViewController: NSViewController {

	// MARK: - DI

	private(set) var adapter: HierarchyTableAdapter?

	var output: (PlanViewOutput & HierarchyDropDelegate)?

	// MARK: - UI-Properties

	lazy var scrollview = NSScrollView.plain

	lazy var table = NSOutlineView.inset

	lazy var bottomBar = BottomBar(frame: .zero)

	// MARK: - Initialization

	init(configure: (HierarchyViewController) -> Void) {
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
		configureNotifications()
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
extension HierarchyViewController: PlanView {

	func display(_ model: HierarchyUnitModel) {
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
private extension HierarchyViewController {

	func configureNotifications() {
		NotificationCenter.default.addObserver(forName: .newItem, object: nil, queue: .main) { [weak self] notification in
			guard let window = notification.object as? NSWindow, self?.view.window === window else {
				return
			}
			self?.output?.createNew()
		}
	}

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
					.priority,
					.setEstimation,
					.separator,
					.setIcon,
					.iconColor,
					.separator,
					.delete
				]
		)
	}
}

extension String {
	static let dateCreatedColumn = "date_created_column"
}
