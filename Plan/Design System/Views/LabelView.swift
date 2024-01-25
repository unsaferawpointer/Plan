//
//  LabelView.swift
//  Plan
//
//  Created by Anton Cherkasov on 23.01.2024.
//

import Cocoa

class LabelView: NSView {

	private (set) var configuration: Configuration? {
		didSet {
			updateUserInterface()
		}
	}

	// MARK: - UI-Properties

	private lazy var label: NSTextField = {
		let view = NSTextField()
		view.isBordered = false
		view.drawsBackground = false
		view.font = NSFont.preferredFont(forTextStyle: .body)
		view.textColor = .controlTextColor
		view.lineBreakMode = .byWordWrapping
		view.usesSingleLineMode = false
		view.cell?.truncatesLastVisibleLine = true
		view.cell?.alignment = .natural
		view.isEditable = true
		view.cell?.sendsActionOnEndEditing = true
		view.target = self
		view.action = #selector(textfieldDidChange(_:))
		return view
	}()

	// MARK: - Initialization

	override init(frame frameRect: NSRect) {
		super.init(frame: frameRect)
		configureConstraints()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

// MARK: - ConfigurableView
extension LabelView: ConfigurableView {

	// MARK: - ConfigurableView

	typealias Configuration = LabelConfiguration

	static var userIdentifier: String = "label"

	func configure(_ configuration: LabelConfiguration) {
		self.configuration = configuration
	}
}

// MARK: - Helpers
private extension LabelView {

	func updateUserInterface() {
		label.stringValue = configuration?.title ?? ""
	}

	func configureConstraints() {

		addSubview(label)
		label.translatesAutoresizingMaskIntoConstraints = false

		NSLayoutConstraint.activate(
			[
				label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
				label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
				label.centerYAnchor.constraint(equalTo: centerYAnchor)
			]
		)

	}
}

// MARK: - Actions
extension LabelView {

	@objc
	func textfieldDidChange(_ sender: NSTextField) {
		guard sender == label else {
			return
		}
		let newValue = sender.stringValue
		configuration?.titleDidChange?(newValue)
	}
}
