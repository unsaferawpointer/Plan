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

	private var converter: Converter = .init()

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
		let newEntity = ProjectEntity(context: context)
		converter.modificate(newEntity, item: project)
	}

	func updateProject(_ id: UUID, modification: (inout ProjectItem) -> Void) throws {
		guard let entity = try fetchEntity(type: ProjectEntity.self, id: id) else {
			return
		}
		var projectItem = converter.convert(entity)
		modification(&projectItem)

		converter.modificate(entity, item: projectItem)
	}

	func addList(_ list: ListItem, toProject projectId: UUID?) throws {

		let newEntity = ListEntity(context: context)
		newEntity.uuid = list.uuid
		newEntity.creationDate = list.creationDate
		newEntity.isFavorite = list.isFavorite
		newEntity.name = list.name

		let predicate = NSPredicate(format: "uuid = %@", argumentArray: [projectId as Any])
		let sortDescriptor = NSSortDescriptor(keyPath: \ProjectEntity.creationDate, ascending: true)
		let projectEntity = try fetchEntity(type: ProjectEntity.self, predicate: predicate, sortDescriptors: [sortDescriptor])

		newEntity.project = projectEntity
	}

	func addTask(_ task: TaskItem, toList listId: UUID?) throws {

		let newEntity = TaskEntity(context: context)
		newEntity.uuid = task.uuid
		newEntity.creationDate = task.creationDate
		newEntity.status = task.status.rawValue
		newEntity.text = task.text

		let predicate = NSPredicate(format: "uuid = %@", argumentArray: [listId as Any])
		let sortDescriptor = NSSortDescriptor(keyPath: \ListEntity.creationDate, ascending: true)
		let listEntity = try fetchEntity(type: ListEntity.self, predicate: predicate, sortDescriptors: [sortDescriptor])

		newEntity.list = listEntity
	}

	func fetchProject(id: UUID) throws -> ProjectItem? {
		let predicate = NSPredicate(format: "uuid = %@", argumentArray: [id as Any])
		guard let entity = try fetchEntity(type: ProjectEntity.self, predicate: predicate, sortDescriptors: []) else {
			return nil
		}
		return .init(
			uuid: entity.uuid,
			name: entity.name,
			creationDate: entity.creationDate
		)
	}

	func fetchList(id: UUID) throws -> ListItem? {
		let predicate = NSPredicate(format: "uuid = %@", argumentArray: [id as Any])
		guard let entity = try fetchEntity(type: ListEntity.self, predicate: predicate, sortDescriptors: []) else {
			return nil
		}
		return .init(
			uuid: entity.uuid,
			name: entity.name,
			isFavorite: entity.isFavorite,
			creationDate: entity.creationDate
		)
	}

	func fetchLists(for projectId: UUID?, sortBy sorting: [ListSorting]) throws -> [ListItem] {
		let predicate = NSPredicate(format: "project.uuid = %@", argumentArray: [projectId as Any])
		let sortDescriptors = sorting.map { listSorting in
			switch listSorting {
			case .creationDate(let ascending):
				return NSSortDescriptor(keyPath: \ListEntity.creationDate, ascending: ascending)
			case .isFavorite(let ascending):
				return NSSortDescriptor(keyPath: \ListEntity.isFavorite, ascending: ascending)
			case .name(let ascending):
				return NSSortDescriptor(keyPath: \ListEntity.name, ascending: ascending)
			case .tasksCount(let ascending):
				return NSSortDescriptor(keyPath: \ListEntity.tasks?.count, ascending: ascending)
			}
		}
		let entities = try fetchEntities(
			type: ListEntity.self,
			predicate: predicate,
			sortDescriptors: sortDescriptors
		)
		return entities.map { entity in
			ListItem(
				uuid: entity.uuid,
				name: entity.name,
				isFavorite: entity.isFavorite,
				creationDate: entity.creationDate
			)
		}
	}

	func fetchProjects(sortBy sorting: [ProjectSorting]) throws -> [ProjectItem] {
		let sortDescriptors = sorting.map { listSorting in
			switch listSorting {
			case .creationDate(let ascending):
				return NSSortDescriptor(keyPath: \ProjectEntity.creationDate, ascending: ascending)
			case .name(let ascending):
				return NSSortDescriptor(keyPath: \ProjectEntity.name, ascending: ascending)
			}
		}
		let entities = try fetchEntities(
			type: ProjectEntity.self,
			predicate: nil,
			sortDescriptors: sortDescriptors
		)
		return entities.map { entity in
			ProjectItem(uuid: entity.uuid, name: entity.name, creationDate: entity.creationDate)
		}
	}

	func fetchTasks(for listId: UUID, sortBy sorting: [TaskSorting]) throws -> [TaskItem] {
		let predicate = NSPredicate(format: "list.uuid = %@", argumentArray: [listId])
		let sortDescriptors = sorting.map {
			switch $0 {
			case .creationDate(let ascending):
				return NSSortDescriptor(keyPath: \TaskEntity.creationDate, ascending: ascending)
			case .text(let ascending):
				return NSSortDescriptor(keyPath: \TaskEntity.text, ascending: ascending)
			case .status(ascending: let ascending):
				return NSSortDescriptor(keyPath: \TaskEntity.status, ascending: ascending)
			}
		}
		let entities = try fetchEntities(
			type: TaskEntity.self,
			predicate: predicate,
			sortDescriptors: sortDescriptors
		)
		return entities.map { entity in
			TaskItem(
				uuid: entity.uuid,
				status: .init(rawValue: entity.status) ?? .incomplete,
				text: entity.text,
				creationDate: entity.creationDate
			)
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

	func fetchEntity<T: NSManagedObject>(type: T.Type, id: UUID) throws -> T? {
		let predicate = NSPredicate(format: "uuid = %@", argumentArray: [id as Any])
		return try fetchEntity(type: type, predicate: predicate, sortDescriptors: [])
	}

}

// MARK: - Nested data structs
extension CoreDataProvider {

	final class Converter {

		func modificate(_ entity: ProjectEntity, item: ProjectItem) {
			entity.uuid = item.uuid
			entity.name = item.name
			entity.creationDate = item.creationDate
		}

		func convert(_ entity: ProjectEntity) -> ProjectItem {
			return .init(
				uuid: entity.uuid,
				name: entity.name,
				creationDate: entity.creationDate
			)
		}
	}
}
