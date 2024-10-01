//
//  PasteboardSupportable.swift
//  Plan
//
//  Created by Anton Cherkasov on 01.10.2024.
//

import Foundation

protocol PasteboardSupportable {

	func paste()
	func canPaste() -> Bool
	func copy()
	func cut()
}
