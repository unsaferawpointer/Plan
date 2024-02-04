//
//  EmptyContentViewController.swift
//  Plan
//
//  Created by Anton Cherkasov on 04.02.2024.
//

import Cocoa

protocol EmptyContentView: AnyObject {
	func display(_ state: EmptyContentViewState)
}

protocol EmptyContentViewOutput: ViewOutput { }

final class EmptyContentViewController: NSViewController {

	var output: EmptyContentViewOutput?

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

	lazy var placeholderView = PlaceholderView(frame: .zero)

	// MARK: - Initialization

	init(configure: (EmptyContentViewController) -> Void) {
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

		output?.viewDidChange(state: .didLoad)
	}
}

// MARK: - PlaceholderView
extension EmptyContentViewController: EmptyContentView {

	func display(_ state: EmptyContentViewState) {
		placeholderView.title = state.title
		placeholderView.subtitle = state.subtitle
		placeholderView.iconView.image = NSImage(named: state.image)
	}
}

// MARK: - Helpers
private extension EmptyContentViewController {

	func configureUserInterface() {

		table.headerView = nil
		scrollview.documentView = table

		table.frame = scrollview.bounds

		let column1 = NSTableColumn(identifier: .init(rawValue: "main"))
		table.addTableColumn(column1)
	}

	func configureConstraints() {
		[scrollview, placeholderView].forEach {
			view.addSubview($0)
			$0.translatesAutoresizingMaskIntoConstraints = false
		}

		NSLayoutConstraint.activate(
			[
				scrollview.leadingAnchor.constraint(equalTo: view.leadingAnchor),
				scrollview.trailingAnchor.constraint(equalTo: view.trailingAnchor),
				scrollview.topAnchor.constraint(equalTo: view.topAnchor),
				scrollview.bottomAnchor.constraint(equalTo: view.bottomAnchor),

				placeholderView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
				placeholderView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
				placeholderView.topAnchor.constraint(equalTo: view.topAnchor),
				placeholderView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
			]
		)
	}
}

