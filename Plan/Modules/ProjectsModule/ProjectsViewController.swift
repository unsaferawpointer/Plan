//
//  ProjectsViewController.swift
//  Plan
//
//  Created by Anton Cherkasov on 27.01.2024.
//

import Cocoa

protocol ProjectsViewOutput: ViewOutput {
	func selectionDidChange(_ newValue: [UUID])
	func labelDidChange(text newValue: String, for id: UUID)
	func toolbarNewProjectButtonHasBeenClicked()
	func deleteProjects(ids: [UUID])
}

protocol ProjectsView: AnyObject {
	func display(_ items: [ProjectConfiguration])
}

final class ProjectsViewController: NSViewController {

	var output: ProjectsViewOutput?

	var adapter: ProjectsTableAdapter?

	// MARK: - UI-Properties

	lazy var scrollview: NSScrollView = {
		let view = NSScrollView()
		view.borderType = .noBorder
		view.hasHorizontalScroller = false
		view.autohidesScrollers = true
		view.hasVerticalScroller = false
		view.automaticallyAdjustsContentInsets = true
		view.drawsBackground = true
		return view
	}()

	lazy var table: NSTableView = {
		let view = NSTableView()
		view.style = .inset
		view.rowSizeStyle = .custom
		view.rowHeight = 50.0
		view.floatsGroupRows = false
		view.allowsMultipleSelection = true
		view.allowsColumnResizing = false
		view.usesAlternatingRowBackgroundColors = false
		view.usesAutomaticRowHeights = false
		view.gridStyleMask = .solidHorizontalGridLineMask
		return view
	}()

	// MARK: - Initialization

	init(configure: (ProjectsViewController) -> Void) {
		super.init(nibName: nil, bundle: nil)
		configure(self)
		configureAdapter()
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
		configureSubscriptions()

		output?.viewDidChange(state: .didLoad)
	}
}

// MARK: - ProjectsView
extension ProjectsViewController: ProjectsView {

	func display(_ items: [ProjectConfiguration]) {
		adapter?.apply(items)
	}
}

// MARK: - Helpers
private extension ProjectsViewController {

	func configureSubscriptions() {
		NotificationCenter.default.addObserver(
			forName: .toolbarNewProjectButtonHasBeenClicked,
			object: nil,
			queue: .main) { [weak self] _ in
				self?.output?.toolbarNewProjectButtonHasBeenClicked()
			}
	}

	func configureAdapter() {

		self.adapter = ProjectsTableAdapter(table: table)

		adapter?.labelDidChangeText = { [weak self] id, newValue in
			self?.output?.labelDidChange(text: newValue, for: id)
		}

		adapter?.selection = { [weak self] ids in
			self?.output?.selectionDidChange(ids)
		}

		adapter?.deletion = { [weak self] id in
			self?.output?.deleteProjects(ids: [id])
		}
	}

	func configureUserInterface() {

		table.headerView = nil
		scrollview.documentView = table

		table.frame = scrollview.bounds

		let column = NSTableColumn(identifier: .init(rawValue: "main"))
		table.addTableColumn(column)
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
