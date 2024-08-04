//
//  BottomBar.swift
//  Plan
//
//  Created by Anton Cherkasov on 04.08.2024.
//

import Cocoa

class BottomBar: NSView {

	var text: String = "Estimation - 12 sp" {
		didSet {
			configureInterface()
		}
	}

	// MARK: - UI-Properties

	lazy var background: NSVisualEffectView = {
		let view = NSVisualEffectView(frame: .zero)
		view.blendingMode = .behindWindow
		view.material = .headerView
		return view
	}()

	lazy var divider: NSView = {
		let view = NSView(frame: .zero)
		view.wantsLayer = true
		return view
	}()

	lazy var label: NSTextField = {
		let view = NSTextField(frame: .zero)
		view.isEditable = false
		view.usesSingleLineMode = true
		view.isBordered = false
		view.drawsBackground = false
		view.textColor = .secondaryLabelColor
		view.font = NSFont.preferredFont(forTextStyle: .callout)
		return view
	}()

	override init(frame frameRect: NSRect) {
		super.init(frame: frameRect)
		configureConstraints()
		configureInterface()
	}
	
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
		label.stringValue = text
	}

	func configureConstraints() {

		[background].forEach {
			$0.translatesAutoresizingMaskIntoConstraints = false
			addSubview($0)
		}

		[label, divider].forEach {
			$0.translatesAutoresizingMaskIntoConstraints = false
			addSubview($0)
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

				label.leadingAnchor.constraint(greaterThanOrEqualTo: background.leadingAnchor, constant: 24),
				label.trailingAnchor.constraint(lessThanOrEqualTo: background.trailingAnchor, constant: -24),
				label.centerYAnchor.constraint(equalTo: background.centerYAnchor),
				label.centerXAnchor.constraint(equalTo: background.centerXAnchor)
			]
		)
	}
}
