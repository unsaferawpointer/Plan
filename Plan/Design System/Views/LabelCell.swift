//
//  LabelCell.swift
//  Plan
//
//  Created by Anton Cherkasov on 02.03.2024.
//

import Cocoa

final class LabelCell: NSView {

	private var configuration: String? {
		didSet {
			updateUserInterface()
		}
	}

	var textAction: ((String) -> Void)?

	// MARK: - UI-Properties

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

extension LabelCell {

	func configure(_ configuration: String) {
		self.configuration = configuration
	}

}

// MARK: - Helpers
private extension LabelCell {

	func updateUserInterface() {

		guard let configuration else {
			return
		}

		titleTextfield.stringValue = configuration
		titleTextfield.textColor = .secondaryLabelColor
	}

	func configureConstraints() {

		[titleTextfield].compactMap { $0 }.forEach {
			addSubview($0)
			$0.translatesAutoresizingMaskIntoConstraints = false
		}

		[
			titleTextfield.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
			titleTextfield.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
			titleTextfield.centerYAnchor.constraint(equalTo: centerYAnchor)
		]
			.forEach { $0.isActive = true }
	}
}

// MARK: - Actions
extension LabelCell {

	@objc
	func textfieldDidChangeText(_ sender: NSTextField) {
		let newValue = sender.stringValue
		textAction?(newValue)
	}
}
