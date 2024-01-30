//
//  TodoCell.swift
//  Plan
//
//  Created by Anton Cherkasov on 29.01.2024.
//

import Cocoa

final class TodoCell: NSView {

	private var configuration: Configuration? {
		didSet {
			updateUserInterface()
		}
	}

	var textAction: ((String) -> Void)?

	// MARK: - UI-Properties

	lazy var stack: NSStackView = {
		let view = NSStackView(views: [checkbox, iconView, textfield])
		view.alignment = .firstBaseline
		view.orientation = .horizontal
		return view
	}()

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

	lazy var textfield: NSTextField = {
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

	lazy var iconView: NSImageView = {
		let view = NSImageView()
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
extension TodoCell: ConfigurableView {

	static var userIdentifier: String = "todocell"

	typealias Configuration = TodoModel

	func configure(_ configuration: Configuration) {
		self.configuration = configuration
	}

}

// MARK: - Helpers
private extension TodoCell {

	func updateUserInterface() {

		guard let configuration else {
			return
		}

		textfield.stringValue = configuration.text
		textfield.textColor = configuration.isDone ? .tertiaryLabelColor : .textColor

		checkbox.state = configuration.isDone ? .on : .off

		iconView.isHidden = !configuration.isFavorite
		iconView.contentTintColor = !configuration.isDone && configuration.isFavorite
			? .systemYellow
			: .secondaryLabelColor
		iconView.image = configuration.isFavorite
		? NSImage(systemSymbolName: "star.fill", accessibilityDescription: nil)?
			.withSymbolConfiguration(.init(scale: .small))
		: NSImage(systemSymbolName: "star", accessibilityDescription: nil)?
			.withSymbolConfiguration(.init(scale: .small))
		iconView.symbolConfiguration = NSImage.SymbolConfiguration(scale: .medium)
	}

	func configureConstraints() {

		[stack].compactMap { $0 }.forEach {
			addSubview($0)
			$0.translatesAutoresizingMaskIntoConstraints = false
		}

		[
			stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
			stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
			stack.centerYAnchor.constraint(equalTo: centerYAnchor)
		]
			.forEach { $0.isActive = true }
	}
}

// MARK: - Actions
extension TodoCell {

	@objc
	func textfieldDidChangeText(_ sender: NSTextField) {
		let newValue = sender.stringValue
		textAction?(newValue)
	}

	@objc
	func checkboxDidChangeState(_ sender: NSButton) {
		let newValue = sender.state == .on
	}
}
