//
//  HeaderField.swift
//  Plan
//
//  Created by Anton Cherkasov on 23.06.2023.
//

import Cocoa

class HeaderField: NSTableCellView, ConfigurableField {

	typealias Configuration = HeaderConfiguration

	static var userIdentifier: String = "header"

	var configuration: Configuration {
		didSet {
			updateInterface()
		}
	}

	func configure(_ configuration: HeaderConfiguration) {
		self.configuration = configuration
	}

	// MARK: - Initialization

	/// Basic initialization
	///
	/// - Parameters:
	///    - configuration: Field configuration
	required init(_ configuration: Configuration) {
		self.configuration = configuration
		super.init(frame: .zero)
		configureUserInterface()
		configureConstraints()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private var trackingArea: NSTrackingArea?

	var isHovering: Bool = false {
		didSet {
			button.isHidden = !isHovering || configuration.button == nil
		}
	}

	var button: NSButton!

	override func updateTrackingAreas() {
		super.updateTrackingAreas()

		if let trackingArea = trackingArea {
			removeTrackingArea(trackingArea)
		}
		trackingArea = nil
		if let _ = window {
			let options:NSTrackingArea.Options = [.mouseEnteredAndExited, .activeAlways]
			self.trackingArea = NSTrackingArea.init(
				rect: bounds,
				options: options,
				owner: self,
				userInfo: nil
			)
			self.addTrackingArea(self.trackingArea!)
		}
	}

	override func mouseEntered(with event: NSEvent) {
		super.mouseEntered(with: event)
		isHovering = true
	}

	override func mouseExited(with event: NSEvent) {
		super.mouseExited(with: event)
		isHovering = false
	}

	deinit {
		if let trackingArea {
			self.removeTrackingArea(trackingArea)
		}
	}
}

// MARK: - HeaderField
private extension HeaderField {

	func updateInterface() {
		textField?.stringValue = configuration.title
		guard let buttonModel = configuration.button else {
			button.isHidden = true
			return
		}
		button.isHidden = false
		button.title = buttonModel.title
	}

	func configureUserInterface() {

		let textfield = NSTextField()
		textfield.isBordered = false
		textfield.font = NSFont.preferredFont(forTextStyle: .headline, options: [:])
		textfield.drawsBackground = false
		textfield.isEditable = false
		textfield.usesSingleLineMode = true
		textfield.lineBreakMode = .byTruncatingMiddle

		let button = NSButton(
			title: "",
			target: self,
			action: #selector(buttonHasBeenPressed(_:))
		)
		button.isHidden = !isHovering || configuration.button == nil
		button.font = NSFont.preferredFont(forTextStyle: .footnote)
		button.isBordered = false
		button.bezelStyle = .texturedRounded
		button.setButtonType(.momentaryPushIn)
		self.button = button
		addSubview(button)

		self.textField = textfield
		addSubview(textfield)
	}
}

// MARK: - Helpers
private extension HeaderField {

	func configureConstraints() {
		guard let textField, let button else {
			return
		}
		[button, textField].forEach {
			$0.translatesAutoresizingMaskIntoConstraints = false
			addSubview($0)
		}

		NSLayoutConstraint.activate(
			[
				textField.leadingAnchor.constraint(equalTo: leadingAnchor),
				textField.trailingAnchor.constraint(lessThanOrEqualTo: button.leadingAnchor, constant: -8),
				textField.centerYAnchor.constraint(equalTo: centerYAnchor),

				button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
				button.firstBaselineAnchor.constraint(equalTo: textField.firstBaselineAnchor)
			]
		)
	}
}

// MARK: - Actions
extension HeaderField {

	@objc
	func buttonHasBeenPressed(_ sender: NSButton) {
		configuration.button?.action()
	}
}
