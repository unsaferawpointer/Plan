//
//  ProjectsDataProvider.swift
//  Plan
//
//  Created by Anton Cherkasov on 28.01.2024.
//

import Foundation
import CoreData

protocol ProjectsDataProviderDelegate: AnyObject {
	func providerDidChangeContent(_ newContent: [Project])
}

protocol ProjectsDataProviderProtocol {
	func subscribe(_ object: ProjectsDataProviderDelegate) throws
}

final class ProjectsDataProvider: NSObject {

	var context: NSManagedObjectContext

	weak var delegate: ProjectsDataProviderDelegate?

	lazy var controller: NSFetchedResultsController<ProjectEntity> = {

		let request = ProjectEntity.fetchRequest()
		request.sortDescriptors = [NSSortDescriptor(keyPath: \ProjectEntity.title, ascending: true)]

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

// MARK: - ProjectsDataProviderProtocol
extension ProjectsDataProvider: ProjectsDataProviderProtocol {

	func subscribe(_ object: ProjectsDataProviderDelegate) throws {
		self.delegate = object

		try controller.performFetch()

		let entities = controller.fetchedObjects ?? []
		let projects = entities.map(\.project)

		delegate?.providerDidChangeContent(projects)
	}
}

// MARK: - NSFetchedResultsControllerDelegate
extension ProjectsDataProvider: NSFetchedResultsControllerDelegate {

	func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) { 

		guard let entities = controller.fetchedObjects as? [ProjectEntity] else {
			return
		}

		let projects = entities.map(\.project)

		delegate?.providerDidChangeContent(projects)
	}
}
