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
	@NSManaged public var rawStatus: Int16
	@NSManaged public var rawUrgency: Int16

	@NSManaged public var creationDate: Date

	// MARK: - Relationships

	@NSManaged public var list: ListEntity?

	public override func awakeFromInsert() {
		super.awakeFromInsert()

		self.uuid = UUID()
		self.text = ""
		self.rawStatus = 0
		self.rawUrgency = 0
		self.creationDate = Date()
	}

	public override func willSave() {
		super.willSave()
	}

}

// MARK: - Calculated properties
extension TodoEntity {

	var status: TodoStatus {
		get {
			return .init(rawValue: rawStatus) ?? .default
		}
		set {
			self.rawStatus = newValue.rawValue
		}
	}

	var urgency: Urgency {
		get {
			return .init(rawValue: rawUrgency) ?? .none
		}
		set {
			self.rawUrgency = newValue.rawValue
		}
	}

	var isDone: Bool {
		get {
			return status == .done
		}
		set {
			if newValue {
				self.status =  .done
			} else {
				self.status = .default
			}
		}
	}
}

// MARK: - Identifiable
extension TodoEntity : Identifiable { }

// MARK: - Support Todo
extension TodoEntity {

	convenience init(_ context: NSManagedObjectContext, todo: Todo) {
		self.init(context: context)

		self.uuid = todo.uuid
		self.creationDate = todo.creationDate
		self.rawStatus = todo.status.rawValue
		self.text = todo.text
		self.rawUrgency = todo.urgency.rawValue
	}

	var todo: Todo {
		return .init(
			uuid: uuid,
			creationDate: creationDate,
			text: text,
			status: status,
			urgency: urgency,
			list: list?.uuid,
			listName: list?.title
		)
	}
}
