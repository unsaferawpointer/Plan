//
//  PersistentContainer.swift
//  Plan
//
//  Created by Anton Cherkasov on 28.01.2024.
//

import Foundation
import CoreData

protocol PersistentContainerProtocol {

	func insertTodo(_ todo: Todo, to list: UUID?) throws

	func deleteTodos(with ids: [UUID]) throws

	func insertList(_ list: List) throws

	func setList(title: String, with id: UUID) throws

	func deleteLists(with ids: [UUID]) throws

	func performModification(_ modification: TodoModification, forTodos ids: [UUID]) throws

	func performModification(_ modification: ListModification, forLists ids: [UUID]) throws

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

	func insertTodo(_ todo: Todo, to list: UUID?) throws {
		let new = TodoEntity(context, todo: todo)

		guard let list, let target = try fetchEntities(ProjectEntity.self, with: [list]).first else {
			return
		}
		new.project = target
	}

	func setTodo(text: String, with id: UUID) throws {
		guard let entity = try fetchEntities(TodoEntity.self, with: [id]).first else {
			return
		}
		entity.text = text
	}

	func setStatus(_ newValue: Bool, forTodos ids: [UUID]) throws {
		let updated = try fetchEntities(TodoEntity.self, with: ids)

		updated.forEach {
			$0.isDone = newValue
		}
	}

	func deleteTodos(with ids: [UUID]) throws {

		let deleted = try fetchEntities(TodoEntity.self, with: ids)

		deleted.forEach {
			context.delete($0)
		}
	}

	func insertList(_ list: List) throws {
		let new = ProjectEntity(context, list: list)
	}

	func setList(title: String, with id: UUID) throws {
		guard let entity = try fetchEntities(ProjectEntity.self, with: [id]).first else {
			return
		}
		entity.title = title
	}

	func deleteLists(with ids: [UUID]) throws {
		let deleted = try fetchEntities(ProjectEntity.self, with: ids)

		deleted.forEach {
			context.delete($0)
		}
	}

	func performModification(_ modification: TodoModification, forTodos ids: [UUID]) throws {

		let entities = try fetchEntities(TodoEntity.self, with: ids)

		for entity in entities {
			switch modification {
			case .setText(let newValue):
				entity.text = newValue
			case .setStatus(let newValue):
				entity.isDone = newValue
			case .bookmark:
				entity.isFavorite = true
			case .unbookmark:
				entity.isFavorite = false
			case .focus:
				entity.inFocus = true
			case .unfocus:
				entity.inFocus = false
			case .setList(let id):
				guard let id, let target = try fetchEntities(ProjectEntity.self, with: [id]).first else {
					entity.project = nil
					return
				}
				entity.project = target
			}
		}
	}

	func performModification(_ modification: ListModification, forLists ids: [UUID]) throws {
		let entities = try fetchEntities(ProjectEntity.self, with: ids)
		for entity in entities {
			switch modification {
			case .setTitle(let newValue):
				entity.title = newValue
			}
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
