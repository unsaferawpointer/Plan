//
//  LabelView.swift
//  Plan
//
//  Created by Anton Cherkasov on 27.01.2024.
//

import Cocoa

final class LabelView: NSTableCellView, ConfigurableView {

	static var userIdentifier: String = "label"

	typealias Configuration = LabelConfig

	private var configuration: Configuration = .init(title: "") {
		didSet {
			updateUserInterface()
		}
	}

	// MARK: - ConfigurableField

	init() {
		super.init(frame: .zero)
		configureConstraints()
		configureUserInterface()
		updateUserInterface()
	}

	func configure(_ configuration: Configuration) {
		self.configuration = configuration
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

// MARK: - Helpers
private extension LabelView {

	func updateUserInterface() {
		textField?.stringValue = configuration.title
		imageView?.image = NSImage(systemSymbolName: configuration.iconName ?? "star.fill", accessibilityDescription: nil)
	}

	func configureUserInterface() {
		let textfield: NSTextField = {
			let view = NSTextField()
			view.isBordered = false
			view.drawsBackground = false
			view.usesSingleLineMode = true
			view.isEditable = false
			view.lineBreakMode = .byTruncatingMiddle
			return view
		}()

		self.textField = textfield
		self.addSubview(textfield)

		let imageView = NSImageView()
		self.imageView = imageView
		self.addSubview(imageView)
	}

	func configureConstraints() {
		guard
			let imageView = imageView,
			let textField = textField
		else {
			return
		}

		textField.setContentHuggingPriority(.defaultLow, for: .horizontal)
		textField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

		[imageView, textField].compactMap { $0 }.forEach {
			$0.translatesAutoresizingMaskIntoConstraints = false
		}

		[
			imageView.centerXAnchor.constraint(equalTo: leadingAnchor, constant: 10.0),
			imageView.centerYAnchor.constraint(equalTo: centerYAnchor),

			textField.lastBaselineAnchor.constraint(equalTo: imageView.lastBaselineAnchor),
			textField.leadingAnchor.constraint(equalTo: imageView.centerXAnchor, constant: 16),
			textField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4)
		]
			.forEach { $0.isActive = true }
	}
}
