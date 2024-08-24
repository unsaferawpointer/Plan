//
//  NSImage+Extension.swift
//  Hierarchy
//
//  Created by Anton Cherkasov on 24.10.2023.
//

import Cocoa

extension NSImage {

	convenience init?(systemSymbolName: String?, accessibilityDescription: String? = nil) {
		guard let name = systemSymbolName else {
			return nil
		}
		self.init(
			systemSymbolName: name,
			accessibilityDescription: accessibilityDescription
		)
	}
}
