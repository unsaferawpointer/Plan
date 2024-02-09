//
//  NSView+Extension.swift
//  Plan
//
//  Created by Anton Cherkasov on 09.02.2024.
//

import Cocoa

extension NSView {

	func pin(to view: NSView) {
		translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(self)

		NSLayoutConstraint.activate(
			[
				leadingAnchor.constraint(equalTo: view.leadingAnchor),
				trailingAnchor.constraint(equalTo: view.trailingAnchor),
				topAnchor.constraint(equalTo: view.topAnchor),
				bottomAnchor.constraint(equalTo: view.bottomAnchor),
			]
		)
	}
}
