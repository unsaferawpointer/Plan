//
//  TableCell.swift
//  Plan
//
//  Created by Anton Cherkasov on 27.08.2024.
//

import Cocoa

protocol TableCell: NSView {

	associatedtype Model

	static var reuseIdentifier: String { get }

	var model: Model { get set }

	init(_ model: Model)

	var action: ((Model) -> Void)? { get set }
}
