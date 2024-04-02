//
//  ListsDataProvider.swift
//  Plan
//
//  Created by Anton Cherkasov on 28.01.2024.
//

import Foundation
import CoreData

protocol ListsDataProviderDelegate: AnyObject {
	func providerDidChangeContent(_ newContent: [List])
}

protocol ListsDataProviderProtocol {
	func subscribe(_ object: ListsDataProviderDelegate) throws
}

final class ListsDataProvider: NSObject {

	var context: NSManagedObjectContext

	weak var delegate: ListsDataProviderDelegate?

	lazy var controller: NSFetchedResultsController<ListEntity> = {

		let request = ListEntity.fetchRequest()
		request.sortDescriptors = [
			NSSortDescriptor(keyPath: \ListEntity.creationDate, ascending: true),
			NSSortDescriptor(keyPath: \ListEntity.title, ascending: true)
		]

		let controller = NSFetchedResultsController(
			fetchRequest: request,
			managedObjectContext: context,
			sectionNameKeyPath: nil,
			cacheName: nil
		)

		controller.delegate = self

		return controller
	}()

	init(context: NSManagedObjectContext) {
		self.context = context
	}
}

// MARK: - ListsDataProviderProtocol
extension ListsDataProvider: ListsDataProviderProtocol {

	func subscribe(_ object: ListsDataProviderDelegate) throws {
		self.delegate = object

		try controller.performFetch()

		let entities = controller.fetchedObjects ?? []
		let lists = entities.map(\.list)

		delegate?.providerDidChangeContent(lists)
	}
}

// MARK: - NSFetchedResultsControllerDelegate
extension ListsDataProvider: NSFetchedResultsControllerDelegate {

	func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) { 

		guard let entities = controller.fetchedObjects as? [ListEntity] else {
			return
		}

		let lists = entities.map(\.list)

		delegate?.providerDidChangeContent(lists)
	}
}
