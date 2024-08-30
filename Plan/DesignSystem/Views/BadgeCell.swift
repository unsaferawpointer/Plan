//
//  BadgeCell.swift
//  Plan
//
//  Created by Anton Cherkasov on 26.08.2024.
//

import Cocoa

final class BadgeCell: NSView, TableCell {
	

	typealias Model = String?

	static var reuseIdentifier: String = "badge_cell"

	var model: Model {
		didSet {
			updateUserInterface()
		}
	}

	var action: ((Model) -> Void)?

	// MARK: - UI-Properties

	lazy var badge: NSButton = {
		let view = NSButton()
		view.setButtonType(.momentaryChange)
		view.bezelStyle = .badge
		view.isHidden = true
		return view
	}()

	// MARK: - Initialization

	init(_ model: Model) {
		self.model = model
		super.init(frame: .zero)
		configureConstraints()
	}

	@available(*, unavailable, message: "Use init(textDidChange: checkboxDidChange:)")
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - NSView life-cycle

	override func prepareForReuse() {
		super.prepareForReuse()
	}
}

// MARK: - Helpers
private extension BadgeCell {

	func updateUserInterface() {
		guard let model else {
			badge.title = ""
			badge.isHidden = true
			return
		}
		badge.isHidden = false
		badge.title = model
	}

	func configureConstraints() {

		[badge].map { $0 }.forEach {
			$0.translatesAutoresizingMaskIntoConstraints = false
			addSubview($0)
		}

		[
			badge.centerYAnchor.constraint(equalTo: centerYAnchor),
			badge.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 4),
			badge.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4)
		]
			.forEach { $0.isActive = true }

	}
}
