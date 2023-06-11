//
//  CoreDataProviderTests.swift
//  PlanTests
//
//  Created by Anton Cherkasov on 10.06.2023.
//

import XCTest
@testable import Plan

final class CoreDataProviderTests: XCTestCase {

	var sut: CoreDataProvider!

	var persistentContainer: NSPersistentContainer!

	override func setUpWithError() throws {
		persistentContainer = {
			let container = NSPersistentContainer(name: "Plan")

			let description = NSPersistentStoreDescription()
			description.url = URL(fileURLWithPath: "/dev/null")
			container.persistentStoreDescriptions = [description]

			container.loadPersistentStores(completionHandler: { _, error in
				if let error = error as NSError? {
					fatalError("Failed to load stores: \(error), \(error.userInfo)")
				}
			})

			return container
		}()
		sut = CoreDataProvider(persistentContainer: persistentContainer)
	}

	override func tearDownWithError() throws {
		sut = nil
	}

}

// MARK: - Helpers
extension CoreDataProviderTests {

	func fetchEntities<T: NSManagedObject>(type: T.Type) throws -> [T]? {
		let fetchRequest = T.fetchRequest()
		let context = persistentContainer.viewContext
		return try context.fetch(fetchRequest) as? [T]
	}

	@discardableResult
	func addProject(_ project: ProjectItem) -> ProjectEntity {

		let context = persistentContainer.viewContext

		let entity = ProjectEntity(context: context)
		entity.uuid = project.uuid
		entity.name = project.name
		entity.creationDate = project.creationDate

		return entity
	}

	@discardableResult
	func addList(_ list: ListItem, to project: ProjectEntity?) -> ListEntity {

		let context = persistentContainer.viewContext

		let entity = ListEntity(context: context)
		entity.uuid = list.uuid
		entity.name = list.name
		entity.creationDate = list.creationDate
		entity.isFavorite = list.isFavorite
		entity.project = project

		return entity
	}

	func addLists(_ lists: [ListItem], to project: ProjectEntity?) {

		let context = persistentContainer.viewContext

		lists.forEach {
			let entity = ListEntity(context: context)
			entity.uuid = $0.uuid
			entity.name = $0.name
			entity.creationDate = $0.creationDate
			entity.isFavorite = $0.isFavorite
			entity.project = project
		}
	}

	func addTasks(_ tasks: [TaskItem], to list: ListEntity?) {

		let context = persistentContainer.viewContext

		tasks.forEach {
			let entity = TaskEntity(context: context)
			entity.uuid = $0.uuid
			entity.text = $0.text
			entity.status = $0.status.rawValue
			entity.creationDate = $0.creationDate
			entity.list = list
		}
	}
}
