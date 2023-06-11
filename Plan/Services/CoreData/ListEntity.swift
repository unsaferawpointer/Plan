//
//  ListEntity+CoreDataProperties.swift
//  Plan
//
//  Created by Anton Cherkasov on 10.06.2023.
//
//

import Foundation
import CoreData

@objc(ListEntity)
public class ListEntity: NSManagedObject { }

extension ListEntity {

	@nonobjc public class func fetchRequest() -> NSFetchRequest<ListEntity> {
		return NSFetchRequest<ListEntity>(entityName: "ListEntity")
	}

	@NSManaged public var uuid: UUID
	@NSManaged public var name: String
	@NSManaged public var isFavorite: Bool
	@NSManaged public var creationDate: Date
	@NSManaged public var tasks: NSSet?
	@NSManaged public var project: ProjectEntity?

	public override func awakeFromInsert() {
		super.awakeFromInsert()
		self.uuid = UUID()
		self.name = ""
		self.isFavorite = false
		self.creationDate = Date()
	}

}

// MARK: Generated accessors for tasks
extension ListEntity {

	@objc(addTasksObject:)
	@NSManaged public func addToTasks(_ value: TaskEntity)

	@objc(removeTasksObject:)
	@NSManaged public func removeFromTasks(_ value: TaskEntity)

	@objc(addTasks:)
	@NSManaged public func addToTasks(_ values: NSSet)

	@objc(removeTasks:)
	@NSManaged public func removeFromTasks(_ values: NSSet)

}

extension ListEntity : Identifiable { }
