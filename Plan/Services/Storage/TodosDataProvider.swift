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

	init(context: NSManagedObjectContext, configuration: TodosConfiguration) {
		self.context = context
		super.init()
		self.controller = configure(with: configuration)
	}
}

// MARK: - Helpers
private extension TodosDataProvider {

	func configure(with configuration: TodosConfiguration) -> NSFetchedResultsController<TodoEntity> {
		let request = TodoEntity.fetchRequest()
		request.sortDescriptors = [NSSortDescriptor(keyPath: \TodoEntity.creationDate, ascending: true)]
		request.predicate = configuration.predicate

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

extension TodosConfiguration {

	var predicate: NSPredicate? {
		switch self {
		case .inFocus:
			return NSPredicate(format: "inFocus == %@ AND isDone == %@", argumentArray: [true, false])
		case .backlog:
			return NSPredicate(format: "inFocus == %@ AND isDone == %@", argumentArray: [false, false])
		case .favorites:
			return NSPredicate(format: "isDone == %@ AND isFavorite == %@", argumentArray: [false, true])
		case .archieve:
			return NSPredicate(format: "isDone == %@", argumentArray: [true])
		case .project(let id):
			return NSPredicate(format: "project.uuid == %@", argumentArray: [id])
		}
	}
}
