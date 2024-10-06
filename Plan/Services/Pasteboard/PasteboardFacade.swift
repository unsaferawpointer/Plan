//
//  PasteboardFacade.swift
//  Plan
//
//  Created by Anton Cherkasov on 12.08.2024.
//

import AppKit

protocol PasteboardFacadeProtocol {

	typealias `Type` = PasteboardInfo.`Type`

	func contains(_ types: Set<`Type`>) -> Bool
	func info(for types: Set<`Type`>) -> PasteboardInfo?
	func setInfo(_ info: PasteboardInfo, clearContents: Bool)
}

final class PasteboardFacade {

	let pasteboard: NSPasteboard

	// MARK: - Initialization

	init(pasteboard: NSPasteboard = .general) {
		self.pasteboard = pasteboard
	}
}

// MARK: - PasteboardFacadeProtocol
extension PasteboardFacade: PasteboardFacadeProtocol {

	func contains(_ types: Set<PasteboardInfo.`Type`>) -> Bool {
		return types.contains { type in
			pasteboard.data(forType: type.value) != nil
		}
	}

	func info(for types: Set<PasteboardInfo.`Type`>) -> PasteboardInfo? {
		let items = pasteboard.pasteboardItems?.map { item in
			let tuples = types.compactMap { identifier -> (PasteboardInfo.`Type`, Data)? in
				guard let data = item.data(forType: identifier.value) else {
					return nil
				}
				return (identifier, data)
			}
			let data = Dictionary(uniqueKeysWithValues: tuples)
			return PasteboardInfo.Item(data: data)
		}

		guard let items else {
			return nil
		}

		return PasteboardInfo(items: items)
	}

	func setInfo(_ info: PasteboardInfo, clearContents: Bool) {

		if clearContents {
			pasteboard.clearContents()
		}

		let items = info.items.map {
			let item = NSPasteboardItem()
			for (key, data) in $0.data {
				item.setData(data, forType: key.value)
			}
			return item
		}

		pasteboard.writeObjects(items)
	}
}
