//
//  TodosDataProvider.swift
//  Plan
//
//  Created by Anton Cherkasov on 30.01.2024.
//

import Foundation
import CoreData

protocol TodosDataProviderDelegate: AnyObject {
	func providerDidChangeContent(_ newContent: [Todo])
}

protocol TodosDataProviderProtocol {
	func subscribe(_ object: TodosDataProviderDelegate) throws
}

final class TodosDataProvider: NSObject {

	private var context: NSManagedObjectContext

	private var controller: NSFetchedResultsController<TodoEntity>?

	weak var delegate: TodosDataProviderDelegate?

	// MARK: - Initialization

	init(context: NSManagedObjectContext, predicate: TodosPredicate, order: [TodosOrder]) {
		self.context = context
		super.init()
		self.controller = configure(with: predicate, order: order)
	}
}

// MARK: - Helpers
private extension TodosDataProvider {

	func configure(with predicate: TodosPredicate, order: [TodosOrder]) -> NSFetchedResultsController<TodoEntity> {
		let request = TodoEntity.fetchRequest()
		request.sortDescriptors = order.map(\.sortDescriptor)
		request.predicate = predicate.predicate

		let controller = NSFetchedResultsController(
			fetchRequest: request,
			managedObjectContext: context,
			sectionNameKeyPath: nil,
			cacheName: nil
		)

		controller.delegate = self
		return controller
	}
}

// MARK: - TodosDataProviderProtocol
extension TodosDataProvider: TodosDataProviderProtocol {

	func subscribe(_ object: TodosDataProviderDelegate) throws {
		self.delegate = object

		try controller?.performFetch()

		let entities = controller?.fetchedObjects ?? []
		let todos = entities.map(\.todo)

		delegate?.providerDidChangeContent(todos)
	}
}

// MARK: - NSFetchedResultsControllerDelegate
extension TodosDataProvider: NSFetchedResultsControllerDelegate {

	func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {

		guard let entities = controller.fetchedObjects as? [TodoEntity] else {
			return
		}

		let todos = entities.map(\.todo)

		delegate?.providerDidChangeContent(todos)
	}
}

extension TodosOrder {

	var sortDescriptor: NSSortDescriptor {
		switch self {
		case .isDone:
			return NSSortDescriptor(keyPath: \TodoEntity.rawStatus, ascending: true)
		case .creationDate:
			return NSSortDescriptor(keyPath: \TodoEntity.creationDate, ascending: true)
		case .urgency:
			return NSSortDescriptor(keyPath: \TodoEntity.rawUrgency, ascending: false)
		case .completionDate:
			return NSSortDescriptor(keyPath: \TodoEntity.completionDate, ascending: false)
		}
	}
}

extension TodosPredicate {

	var predicate: NSPredicate {
		switch self {
		case .list(let id):
			return NSPredicate(format: "list.uuid == %@", argumentArray: [id ?? NSNull()])
		case .status(let value):
			return NSPredicate(format: "rawStatus == %@", argumentArray: [value.rawValue])
		}
	}
}
