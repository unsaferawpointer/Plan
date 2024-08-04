//
//  NSTextField+Extension.swift
//  Hierarchy
//
//  Created by Anton Cherkasov on 24.10.2023.
//

import Cocoa

extension NSTextField {

	var text: String? {
		get {
			return stringValue
		}
		set {
			self.stringValue = newValue ?? ""
		}
	}
}
