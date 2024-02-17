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
	@NSManaged public var isFavorite: Bool

	@NSManaged public var startDate: Date?
	@NSManaged public var creationDate: Date
	@NSManaged public var completionDate: Date?

	// MARK: - Relationships

	@NSManaged public var list: ListEntity?

	public override func awakeFromInsert() {
		super.awakeFromInsert()

		self.uuid = UUID()
		self.text = ""
		self.isFavorite = isFavorite
		self.creationDate = Date()
	}

	public override func willSave() {
		if !isDeleted, let date = completionDate {
			let max = max(creationDate, date)
			let keyPath = NSExpression(forKeyPath: \TodoEntity.creationDate).keyPath
			setPrimitiveValue(max, forKey: keyPath)
		}
		super.willSave()
	}

}

// MARK: - Calculated properties
extension TodoEntity {

	var isDone: Bool {
		get {
			return completionDate != nil
		}
		set {
			completionDate = newValue ? Date() : nil
		}
	}

	var status: TodoStatus {
		get {
			switch (startDate, completionDate) {
			case (.some(let start), .none):
				return .inProgress(startDate: start)
			case (.some(let start), .some(let end)):
				return .isDone(startDate: start, completionDate: end)
			default:
				return .incomplete
			}
		}
		set {
			switch newValue {
			case .incomplete:
				self.startDate = nil
				self.completionDate = nil
			case .inProgress(let start):
				self.startDate = start
				self.completionDate = nil
			case .isDone(let start, let end):
				self.startDate = start
				self.completionDate = end
			}
		}
	}
}

extension TodoEntity {

	func start() {
		switch status {
		case .incomplete:
			self.status = .inProgress(startDate: Date())
		default:
			break
		}
	}

	func complete() {
		switch status {
		case .incomplete:
			let date = Date()
			self.status = .isDone(startDate: date, completionDate: date)
		case .inProgress(let start):
			self.status = .isDone(startDate: start, completionDate: Date())
		case .isDone:
			break
		}
	}

	func moveToBacklog() {
		self.status = .incomplete
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
		self.startDate = todo.status.startDate
		self.completionDate = todo.status.completionDate
		self.text = todo.text
		self.isFavorite = todo.isFavorite
	}

	var todo: Todo {
		return .init(
			uuid: uuid,
			creationDate: creationDate,
			text: text,
			isFavorite: isFavorite,
			status: status,
			list: list?.uuid,
			listName: list?.title
		)
	}
}
