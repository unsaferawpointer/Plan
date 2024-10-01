//
//  TableSupportable.swift
//  Plan
//
//  Created by Anton Cherkasov on 01.10.2024.
//

import Foundation

protocol TableSupportable {
	func scroll(to id: UUID)
	func select(_ id: UUID)
	func focus(on id: UUID)
	var selection: [UUID] { get }
}
