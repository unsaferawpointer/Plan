//
//  NSMenu+Extension.swift
//  Plan
//
//  Created by Anton Cherkasov on 31.03.2024.
//

import AppKit

extension NSMenu {

	convenience init(items: [NSMenuItem]) {
		self.init()
		for item in items {
			addItem(item)
		}
	}
}
