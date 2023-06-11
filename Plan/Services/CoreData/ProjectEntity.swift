//
//  ProjectEntity+CoreDataProperties.swift
//  Plan
//
//  Created by Anton Cherkasov on 10.06.2023.
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
	@NSManaged public var name: String
	@NSManaged public var creationDate: Date
	@NSManaged public var lists: NSSet?

	public override func awakeFromInsert() {
		super.awakeFromInsert()
		self.uuid = UUID()
		self.name = ""
		self.creationDate = Date()
	}

}

// MARK: Generated accessors for lists
extension ProjectEntity {

	@objc(addListsObject:)
	@NSManaged public func addToLists(_ value: ListEntity)

	@objc(removeListsObject:)
	@NSManaged public func removeFromLists(_ value: ListEntity)

	@objc(addLists:)
	@NSManaged public func addToLists(_ values: NSSet)

	@objc(removeLists:)
	@NSManaged public func removeFromLists(_ values: NSSet)

}

extension ProjectEntity : Identifiable { }
