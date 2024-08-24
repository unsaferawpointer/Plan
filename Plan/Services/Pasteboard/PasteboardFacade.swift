//
//  PasteboardFacade.swift
//  Plan
//
//  Created by Anton Cherkasov on 12.08.2024.
//

import AppKit

protocol PasteboardFacadeProtocol {
	func getString() -> String?
	func setString(_ value: String)
}

final class PasteboardFacade { 
	let pasteboard = NSPasteboard.general
}

// MARK: - PasteboardFacadeProtocol
extension PasteboardFacade: PasteboardFacadeProtocol {

	func getString() -> String? {
		return pasteboard.string(forType: .string)
	}

	func setString(_ value: String) {
		pasteboard.clearContents()
		pasteboard.setString(value, forType: .string)
	}
}
