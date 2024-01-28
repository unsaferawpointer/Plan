//
//  TodoEntity+CoreDataProperties.swift
//  Plan
//
//  Created by Anton Cherkasov on 28.01.2024.
//
//

import Foundation
import CoreData

@objc(TodoEntity)
public class TodoEntity: NSManagedObject { }

extension TodoEntity {

	@nonobjc public class func fetchRequest() -> NSFetchRequest<TodoEntity> {
		return NSFetchRequest<TodoEntity>(entityName: "TodoEntity")
	}

	@NSManaged public var uuid: UUID
	@NSManaged public var text: String
	@NSManaged public var options: Int64
	@NSManaged public var creationDate: Date
	@NSManaged public var isDone: Bool
	@NSManaged public var project: ProjectEntity?

	public override func awakeFromInsert() {
		super.awakeFromInsert()

		self.uuid = UUID()
		self.text = ""
		self.options = 0
		self.creationDate = Date()
		self.isDone = false
	}

}

// MARK: - Identifiable
extension TodoEntity : Identifiable { }
