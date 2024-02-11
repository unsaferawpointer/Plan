//
//  ProjectEntity+CoreDataProperties.swift
//  Plan
//
//  Created by Anton Cherkasov on 28.01.2024.
//
//

import Foundation
import CoreData

@objc(ProjectEntity)
public class ProjectEntity: NSManagedObject { }

extension ProjectEntity {

	@nonobjc public class func fetchRequest() -> NSFetchRequest<ProjectEntity> {
		return NSFetchRequest<ProjectEntity>(entityName: "ProjectEntity")
	}

	@NSManaged public var uuid: UUID
	@NSManaged public var title: String
	@NSManaged public var creationDate: Date
	@NSManaged public var isArchived: Bool
	@NSManaged public var todos: NSSet?

	public override func awakeFromInsert() {
		super.awakeFromInsert()

		self.uuid = UUID()
		self.title = ""
		self.creationDate = Date()
		self.isArchived = false
	}

}

// MARK: Generated accessors for todos
extension ProjectEntity {

	@objc(addTodosObject:)
	@NSManaged public func addToTodos(_ value: TodoEntity)

	@objc(removeTodosObject:)
	@NSManaged public func removeFromTodos(_ value: TodoEntity)

	@objc(addTodos:)
	@NSManaged public func addToTodos(_ values: NSSet)

	@objc(removeTodos:)
	@NSManaged public func removeFromTodos(_ values: NSSet)

}

// MARK: - Identifiable
extension ProjectEntity: Identifiable { }

// MARK: - Support Project
extension ProjectEntity {

	convenience init(_ context: NSManagedObjectContext, list: List) {
		self.init(context: context)

		self.uuid = list.uuid
		self.title = list.title
	}

	var list: List {
		return List(
			uuid: uuid,
			title: title,
			count: todos?.count ?? 0
		)
	}
}
