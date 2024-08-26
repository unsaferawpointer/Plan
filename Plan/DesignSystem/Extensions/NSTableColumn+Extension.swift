//
//  NSTableColumn.swift
//  Plan
//
//  Created by Anton Cherkasov on 26.08.2024.
//

import Cocoa

extension NSTableColumn {

	convenience init(with identifier: String) {
		self.init(identifier: .init(identifier))
	}
}
