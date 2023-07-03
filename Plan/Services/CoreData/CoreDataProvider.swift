//
//  CoreDataProvider.Storage.swift
//  Plan
//
//  Created by Anton Cherkasov on 10.06.2023.
//

import CoreData

/// CoreData data provider
final class CoreDataProvider {

	private var persistentContainer: NSPersistentContainer

	private var context: NSManagedObjectContext {
		return persistentContainer.viewContext
	}

	// MARK: - Initialization

	/// Basic initialization
	init(persistentContainer: NSPersistentContainer?) {
		if let persistentContainer {
			self.persistentContainer = persistentContainer
		} else {
			self.persistentContainer = {
				let container = NSPersistentCloudKitContainer(name: "Plan")
				container.loadPersistentStores { (storeDescription, error) in
					if let error {
						// Replace this implementation with code to handle the error appropriately.
						// fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

						/*
						 Typical reasons for an error here include:
						 * The parent directory does not exist, cannot be created, or disallows writing.
						 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
						 * The device is out of space.
						 * The store could not be migrated to the current model version.
						 Check the error message to determine what the actual problem was.
						 */
						fatalError()
					}
				}
				return container
			}()
		}
	}
}

// MARK: - DataProvider
extension CoreDataProvider: DataProvider {

	func addProject(_ project: ProjectItem) throws {
		_ = ProjectEntity(from: project, context: context)
	}

	func updateProject(_ id: UUID, modification: (inout ProjectItem) -> Void) throws {
		guard let entity = try fetchEntity(type: ProjectEntity.self, id: id) else {
			return
		}
		var projectItem = entity.item
		modification(&projectItem)

		entity.update(by: projectItem)
	}

	func deleteProject(_ id: UUID) throws {
		guard let entity = try fetchEntity(type: ProjectEntity.self, id: id) else {
			return
		}
		context.delete(entity)
	}

	func addList(_ list: ListItem, toProject projectId: UUID?) throws {
		let newEntity = ListEntity(from: list, context: context)
		let projectEntity = try fetchEntity(type: ProjectEntity.self, id: projectId)
		newEntity.project = projectEntity
	}

	func addTask(_ task: TaskItem, toList listId: UUID?) throws {
		let newEntity = TaskEntity(from: task, context: context)
		let listEntity = try fetchEntity(type: ListEntity.self, id: listId)
		newEntity.list = listEntity
	}

	func fetchProject(id: UUID) throws -> ProjectItem? {
		return try fetchEntity(type: ProjectEntity.self, id: id)?.item
	}

	func fetchList(id: UUID) throws -> ListItem? {
		return try fetchEntity(type: ListEntity.self, id: id)?.item
	}

	func fetchLists(for projectId: UUID?, sortBy sorting: [ListSorting]) throws -> [ListItem] {
		let predicate = NSPredicate(format: "project.uuid = %@", argumentArray: [projectId as Any])
		let sortDescriptors = sorting.map(\.sortDescriptor)
		let entities = try fetchEntities(
			type: ListEntity.self,
			predicate: predicate,
			sortDescriptors: sortDescriptors
		)
		return entities.map(\.item)
	}

	func fetchProjects(sortBy sorting: [ProjectSorting]) throws -> [ProjectItem] {
		let sortDescriptors = sorting.map(\.sortDescriptor)
		let entities = try fetchEntities(
			type: ProjectEntity.self,
			predicate: nil,
			sortDescriptors: sortDescriptors
		)
		return entities.map(\.item)
	}

	func fetchTasks(for listId: UUID, sortBy sorting: [TaskSorting]) throws -> [TaskItem] {
		let predicate = NSPredicate(format: "list.uuid = %@", argumentArray: [listId])
		let sortDescriptors = sorting.map(\.sortDescriptor)
		let entities = try fetchEntities(
			type: TaskEntity.self,
			predicate: predicate,
			sortDescriptors: sortDescriptors
		)
		return entities.map (\.item)
	}

	func save() throws {
		guard context.hasChanges else {
			return
		}
		try context.save()
	}
}

// MARK: - Helpers
private extension CoreDataProvider {

	func fetchEntities<T: NSManagedObject>(type: T.Type,
										   predicate: NSPredicate?,
										   sortDescriptors: [NSSortDescriptor]) throws -> [T] {
		precondition(!sortDescriptors.isEmpty, "Should have one or more sort descriptors")
		let fetchRequest = type.fetchRequest()
		fetchRequest.predicate = predicate
		fetchRequest.sortDescriptors = sortDescriptors
		let entities = try context.fetch(fetchRequest) as? [T]
		return entities ?? []
	}

	func fetchEntity<T: NSManagedObject>(type: T.Type,
										 predicate: NSPredicate?,
										 sortDescriptors: [NSSortDescriptor]
	) throws -> T? {
		let fetchRequest  = type.fetchRequest()
		fetchRequest.predicate = predicate
		fetchRequest.fetchLimit = 1
		fetchRequest.sortDescriptors = sortDescriptors
		let entities = try context.fetch(fetchRequest) as? [T]
		return entities?.first
	}

	func fetchEntity<T: NSManagedObject>(type: T.Type, id: UUID?) throws -> T? {
		guard let id else {
			return nil
		}
		let predicate = NSPredicate(format: "uuid = %@", argumentArray: [id as Any])
		return try fetchEntity(type: type, predicate: predicate, sortDescriptors: [])
	}

}
