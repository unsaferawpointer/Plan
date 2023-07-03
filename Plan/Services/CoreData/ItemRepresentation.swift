//
//  ItemRepresentation.swift
//  Plan
//
//  Created by Anton Cherkasov on 02.07.2023.
//

import CoreData

/// Interface of the converting to item
protocol ItemRepresentation: NSManagedObject {

	associatedtype Item

	/// Item representation
	var item: Item { get }

	/// Update managed object by item representation
	func update(by item: Item)

	/// Initialization from item representation
	init(from item: Item, context: NSManagedObjectContext)
}
