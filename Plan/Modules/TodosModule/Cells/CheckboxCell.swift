//
//  CheckboxCell.swift
//  Plan
//
//  Created by Anton Cherkasov on 02.03.2024.
//

import Cocoa

final class CheckboxCell: NSView {

	private var configuration: Configuration? {
		didSet {
			updateUserInterface()
		}
	}

	var textAction: ((String) -> Void)?

	var checkboxAction: ((Bool) -> Void)?

	// MARK: - UI-Properties

	lazy var checkbox: NSButton = {
		let selector = #selector(checkboxDidChangeState(_:))
		let view = NSButton(
			checkboxWithTitle: "",
			target: self,
			action: selector
		)
		view.allowsMixedState = false
		view.image = NSImage(symbolName: "checkbox", variableValue: 0.0)?
			.withSymbolConfiguration(.init(scale: .medium))?
			.withSymbolConfiguration(.init(textStyle: .body))
		view.alternateImage = NSImage(systemSymbolName: "checkmark", accessibilityDescription: nil)?
			.withSymbolConfiguration(.init(scale: .medium))?
			.withSymbolConfiguration(.init(textStyle: .body))
		view.contentTintColor = .tertiaryLabelColor
		return view
	}()

	lazy var titleTextfield: NSTextField = {
		let view = NSTextField()
		view.focusRingType = .default
		view.cell?.sendsActionOnEndEditing = true
		view.isBordered = false
		view.drawsBackground = false
		view.usesSingleLineMode = true
		view.lineBreakMode = .byTruncatingMiddle
		view.font = NSFont.preferredFont(forTextStyle: .body)
		view.cell?.sendsActionOnEndEditing = true
		view.target = self
		view.action = #selector(textfieldDidChangeText(_:))
		return view
	}()

	// MARK: - ConfigurableField

	init() {
		super.init(frame: .zero)
		configureConstraints()
		updateUserInterface()
	}

	@available(*, unavailable, message: "Use init(_:)")
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - NSView life-cycle

	override func prepareForReuse() {
		super.prepareForReuse()
	}
}

// MARK: - ConfigurableView
extension CheckboxCell: ConfigurableView {

	static var userIdentifier: String = "CheckboxCell"

	typealias Configuration = TodoModel

	func configure(_ configuration: Configuration) {
		self.configuration = configuration
	}

}

// MARK: - Helpers
private extension CheckboxCell {

	func updateUserInterface() {

		guard let configuration else {
			return
		}

		titleTextfield.stringValue = configuration.text
		titleTextfield.textColor = configuration.isDone ? .secondaryLabelColor : .controlTextColor

		checkbox.state = configuration.isDone ? .on : .off
	}

	func configureConstraints() {

		[checkbox, titleTextfield].compactMap { $0 }.forEach {
			addSubview($0)
			$0.translatesAutoresizingMaskIntoConstraints = false
		}

		[
			checkbox.leadingAnchor.constraint(equalTo: leadingAnchor),
			checkbox.centerYAnchor.constraint(equalTo: centerYAnchor),

			titleTextfield.leadingAnchor.constraint(equalTo: checkbox.trailingAnchor, constant: 8),
			titleTextfield.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
			titleTextfield.firstBaselineAnchor.constraint(equalTo: checkbox.firstBaselineAnchor)
		]
			.forEach { $0.isActive = true }
	}
}

// MARK: - Actions
extension CheckboxCell {

	@objc
	func textfieldDidChangeText(_ sender: NSTextField) {
		let newValue = sender.stringValue
		textAction?(newValue)
	}

	@objc
	func checkboxDidChangeState(_ sender: NSButton) {
		let newValue = sender.state == .on
		checkboxAction?(newValue)
	}
}
