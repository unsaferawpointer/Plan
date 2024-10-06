//
//  BottomBar.swift
//  Plan
//
//  Created by Anton Cherkasov on 04.08.2024.
//

import Cocoa

class BottomBar: NSView {

	var model: Model = .init() {
		didSet {
			configureInterface()
		}
	}

	var progressValue: Double = 0.0 {
		didSet {
			configureInterface()
		}
	}

	var trailingText: String = "" {
		didSet {
			configureInterface()
		}
	}

	// MARK: - UI-Properties

	lazy var background: NSVisualEffectView = {
		let view = NSVisualEffectView(frame: .zero)
		view.blendingMode = .withinWindow
		view.material = .headerView
		return view
	}()

	lazy var divider: NSView = {
		let view = NSView(frame: .zero)
		view.wantsLayer = true
		return view
	}()

	lazy var leadingLabel: NSTextField = {
		let view = NSTextField(frame: .zero)
		view.isEditable = false
		view.usesSingleLineMode = true
		view.isBordered = false
		view.drawsBackground = false
		view.textColor = .secondaryLabelColor
		view.font = NSFont.preferredFont(forTextStyle: .callout)

		// Accessibility
		view.identifier = .init("leading-label")
		view.setAccessibilityRole(.staticText)
		return view
	}()

	lazy var trailingLabel: NSTextField = {
		let view = NSTextField(frame: .zero)
		view.isEditable = false
		view.usesSingleLineMode = true
		view.isBordered = false
		view.drawsBackground = false
		view.textColor = .secondaryLabelColor
		view.font = NSFont.preferredFont(forTextStyle: .callout)

		// Accessibility
		view.identifier = .init("trailing-label")
		view.setAccessibilityRole(.staticText)
		return view
	}()

	lazy var progress: NSProgressIndicator = {
		let view = NSProgressIndicator(frame: .zero)
		view.isIndeterminate = false
		view.minValue = 0.0
		view.maxValue = 100.0

		// Accessibility
		view.identifier = .init("progress")
		return view
	}()

	lazy var stack: NSStackView = {
		let view = NSStackView(views: [leadingLabel, NSView(), trailingLabel])
		view.orientation = .horizontal
		view.spacing = 0
		return view
	}()

	override init(frame frameRect: NSRect) {
		super.init(frame: frameRect)
		configureConstraints()
		configureInterface()
	}

	// MARK: - Accessibility

	override func accessibilityRole() -> NSAccessibility.Role? {
		return .group
	}

	override func isAccessibilityElement() -> Bool {
		return true
	}

	// MARK: - View lifecycle

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func layout() {
		super.layout()
		divider.layer?.backgroundColor = NSColor.separatorColor.cgColor
	}

}

extension BottomBar {

	func configureInterface() {
		leadingLabel.stringValue = model.leadingText
		trailingLabel.stringValue = model.trailingText
		progress.doubleValue = model.progress ?? 0

		// MARK: - Accessibility
		identifier = .init("bottom-bar")
	}

	func configureConstraints() {

		[background, divider].forEach {
			$0.translatesAutoresizingMaskIntoConstraints = false
			addSubview($0)
		}

		[stack, progress].forEach {
			$0.translatesAutoresizingMaskIntoConstraints = false
			background.addSubview($0)
		}

		NSLayoutConstraint.activate(
			[
				divider.leadingAnchor.constraint(equalTo: background.leadingAnchor),
				divider.trailingAnchor.constraint(equalTo: background.trailingAnchor),
				divider.topAnchor.constraint(equalTo: background.topAnchor),
				divider.heightAnchor.constraint(equalToConstant: 1),

				background.leadingAnchor.constraint(equalTo: leadingAnchor),
				background.trailingAnchor.constraint(equalTo: trailingAnchor),
				background.bottomAnchor.constraint(equalTo: bottomAnchor),
				background.topAnchor.constraint(equalTo: topAnchor),

				stack.leadingAnchor.constraint(equalTo: background.leadingAnchor, constant: 24),
				stack.trailingAnchor.constraint(equalTo: background.trailingAnchor, constant: -24),
				stack.topAnchor.constraint(equalTo: background.topAnchor, constant: 8),
				stack.bottomAnchor.constraint(equalTo: progress.topAnchor),

				progress.leadingAnchor.constraint(equalTo: background.leadingAnchor, constant: 24),
				progress.trailingAnchor.constraint(equalTo: background.trailingAnchor, constant: -24),
				progress.bottomAnchor.constraint(equalTo: background.bottomAnchor, constant: -8)
			]
		)
	}
}

// MARK: - Nested data structs
extension BottomBar {

	struct Model {

		let leadingText: String
		let trailingText: String

		let progress: Double?

		// MARK: - Initialization

		init(
			leadingText: String = "",
			trailingText: String = "",
			progress: Double? = nil
		) {
			self.leadingText = leadingText
			self.trailingText = trailingText
			self.progress = progress
		}
	}
}
