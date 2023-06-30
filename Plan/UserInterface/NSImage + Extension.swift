//
//  NSImage + Extension.swift
//  Plan
//
//  Created by Anton Cherkasov on 30.06.2023.
//

import Cocoa

extension NSImage {

	convenience init?(systemSymbolName: String?) {
		guard let name = systemSymbolName else {
			return nil
		}
		self.init(
			systemSymbolName: name,
			accessibilityDescription: nil
		)
	}

}
