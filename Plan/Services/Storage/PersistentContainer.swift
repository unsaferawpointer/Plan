//
//  PersistentContainer.swift
//  Plan
//
//  Created by Anton Cherkasov on 28.01.2024.
//

import Foundation
import CoreData

protocol PersistentContainerProtocol {

	func insertTodo(_ todo: Todo, to project: UUID?) throws

	func deleteTodos(with ids: [UUID]) throws

	func insertProject(_ project: Project) throws

	func deleteProjects(with ids: [UUID]) throws

	func save() throws
}

final class PersistentContainer {

	var context: NSManagedObjectContext

	// MARK: - Initialization

	init(context: NSManagedObjectContext) {
		self.context = context
	}
}

// MARK: - PersistentContainerProtocol
extension PersistentContainer: PersistentContainerProtocol {

	func insertTodo(_ todo: Todo, to project: UUID?) throws {
		let new = TodoEntity(context, todo: todo)

		guard let project, let target = try fetchEntities(ProjectEntity.self, with: [project]).first else {
			return
		}
		new.project = target
	}

	func deleteTodos(with ids: [UUID]) throws {

		let deleted = try fetchEntities(TodoEntity.self, with: ids)

		deleted.forEach {
			context.delete($0)
		}
	}

	func insertProject(_ project: Project) throws {
		let new = ProjectEntity(context, project: project)
	}

	func deleteProjects(with ids: [UUID]) throws {
		let deleted = try fetchEntities(ProjectEntity.self, with: ids)

		deleted.forEach {
			context.delete($0)
		}
	}

	func save() throws {
		guard context.hasChanges else {
			return
		}

		try context.save()
	}
}

// MARK: - Helpers
private extension PersistentContainer {

	func fetchEntities<T: NSManagedObject>(_ entity: T.Type, with ids: [UUID]) throws -> [T] {

		guard !ids.isEmpty else {
			return []
		}

		let predicate = NSPredicate(format: "uuid IN %@", argumentArray: [ids])

		let request: NSFetchRequest<T> = entity.fetchRequest() as! NSFetchRequest<T>
		request.predicate = predicate
		request.fetchLimit = ids.count

		return try context.fetch(request)
	}
}

extension TodoEntity {

	convenience init(_ context: NSManagedObjectContext, todo: Todo) {
		self.init(context: context)

		self.uuid = todo.uuid
		self.creationDate = todo.creationDate
		self.isDone = todo.isDone
		self.text = todo.text
		self.options = todo.options
	}
}
