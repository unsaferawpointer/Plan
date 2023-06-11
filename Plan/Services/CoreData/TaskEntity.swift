//
//  TaskEntity+CoreDataProperties.swift
//  Plan
//
//  Created by Anton Cherkasov on 10.06.2023.
//
//

import Foundation
import CoreData

@objc(TaskEntity)
public class TaskEntity: NSManagedObject { }

extension TaskEntity {
	
	@nonobjc public class func fetchRequest() -> NSFetchRequest<TaskEntity> {
		return NSFetchRequest<TaskEntity>(entityName: "TaskEntity")
	}
	
	@NSManaged public var uuid: UUID
	@NSManaged public var text: String
	@NSManaged public var status: Int16
	@NSManaged public var creationDate: Date
	@NSManaged public var list: ListEntity?

	public override func awakeFromInsert() {
		super.awakeFromInsert()
		self.uuid = UUID()
		self.text = ""
		self.status = 0
		self.creationDate = Date()
	}
	
}

extension TaskEntity : Identifiable { }
