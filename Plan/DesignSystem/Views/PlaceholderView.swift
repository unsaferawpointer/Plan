//
//  PlaceholderView.swift
//  Hierarchy
//
//  Created by Anton Cherkasov on 17.10.2023.
//

import Cocoa

class PlaceholderView: NSView {

	// MARK: - Data

	var title: String {
		get {
			titleLabel.stringValue
		}
		set {
			titleLabel.stringValue = newValue
		}
	}

	var subtitle: String {
		get {
			subtitleLabel.stringValue
		}
		set {
			subtitleLabel.stringValue = newValue
		}
	}

	// MARK: - UI-Properties

	lazy var iconView: NSImageView = {
		let view = NSImageView()
		view.image = NSImage(named: "ghost")
		view.imageScaling = .scaleProportionallyUpOrDown
		return view
	}()

	lazy var titleLabel: NSTextField = {
		let field = NSTextField()
		field.drawsBackground = false
		field.isEditable = false
		field.isBordered = false
		field.font = NSFont.preferredFont(forTextStyle: .headline)
		field.textColor = .labelColor
		return field
	}()

	lazy var subtitleLabel: NSTextField = {
		let field = NSTextField()
		field.drawsBackground = false
		field.isEditable = false
		field.isBordered = false
		field.font = NSFont.preferredFont(forTextStyle: .body)
		field.textColor = .secondaryLabelColor
		return field
	}()

	lazy var stack: NSStackView = {
		let view = NSStackView(views: [iconView, titleLabel, subtitleLabel])
		view.orientation = .vertical
		view.distribution = .fill
		view.setCustomSpacing(24, after: iconView)
		return view
	}()

	// MARK: - Initialization

	override init(frame frameRect: NSRect) {
		super.init(frame: frameRect)
		configureConstraints()
	}
	
	@available(*, unavailable, message: "Use init(frame:)")
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}

// MARK: - Helpers
private extension PlaceholderView {

	func configureConstraints() {
		[stack].forEach {
			addSubview($0)
			$0.translatesAutoresizingMaskIntoConstraints = false
		}

		NSLayoutConstraint.activate(
			[
				stack.centerYAnchor.constraint(equalTo: centerYAnchor),
				stack.centerXAnchor.constraint(equalTo: centerXAnchor),

				iconView.heightAnchor.constraint(equalToConstant: 86),
				iconView.widthAnchor.constraint(equalToConstant: 86)
			]
		)
	}
}
