//
//  PasteboardFacade.swift
//  Plan
//
//  Created by Anton Cherkasov on 12.08.2024.
//

import AppKit

protocol PasteboardFacadeProtocol {
	func getString() -> String?
}

final class PasteboardFacade {

}

// MARK: - PasteboardFacadeProtocol
extension PasteboardFacade: PasteboardFacadeProtocol {

	func getString() -> String? {
		return NSPasteboard.general.string(forType: .string)
	}
}
