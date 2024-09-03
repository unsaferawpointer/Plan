//
//  NumberCell.swift
//  Plan
//
//  Created by Anton Cherkasov on 03.09.2024.
//

import Cocoa

final class NumberCell: NSView, TableCell {

	static var reuseIdentifier: String = "number_cell"

	var model: Model {
		didSet {
			updateUserInterface()
		}
	}

	var action: ((Model) -> Void)?

	// MARK: - UI-Properties

	lazy var textfield: NSTextField = {
		let view = NSTextField()
		view.focusRingType = .default
		view.isBordered = false
		view.drawsBackground = false
		view.usesSingleLineMode = true
		view.lineBreakMode = .byTruncatingMiddle
		view.font = NSFont.preferredFont(forTextStyle: .callout)
		view.textColor = .secondaryLabelColor
		view.alignment = .right
		view.isEditable = false
		view.target = self
		view.action = #selector(textfieldDidChange(_:))
		view.formatter = ValueFormatter()
		view.cell?.sendsActionOnEndEditing = true
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
private extension NumberCell {

	func updateUserInterface() {

		textfield.isEditable = model.isEditable
		textfield.textColor = model.isEditable ? .secondaryLabelColor : .tertiaryLabelColor
		textfield.formatter = model.isEditable ? ValueFormatter() : nil

		guard model.value > 0 else {
			textfield.stringValue = ""
			return
		}
		textfield.stringValue = "\(model.value)"
	}

	func configureConstraints() {

		[textfield].map { $0 }.forEach {
			$0.translatesAutoresizingMaskIntoConstraints = false
			addSubview($0)
		}

		[
			textfield.centerYAnchor.constraint(equalTo: centerYAnchor),
			textfield.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4),
			textfield.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4)
		]
			.forEach { $0.isActive = true }

	}
}

// MARK: - Actions
extension NumberCell {

	@objc
	func textfieldDidChange(_ sender: NSTextField) {
		guard sender === textfield else {
			return
		}
		action?(.init(isEditable: false, value: sender.integerValue))
	}

}

extension NumberCell {

	struct Model {
		let isEditable: Bool
		let value: Int
	}
}
