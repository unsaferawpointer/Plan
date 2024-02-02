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
	@NSManaged public var inFocus: Bool
	@NSManaged public var isFavorite: Bool
	@NSManaged public var creationDate: Date
	@NSManaged public var isDone: Bool
	@NSManaged public var project: ProjectEntity?

	public override func awakeFromInsert() {
		super.awakeFromInsert()

		self.uuid = UUID()
		self.text = ""
		self.inFocus = false
		self.isFavorite = isFavorite
		self.creationDate = Date()
		self.isDone = false
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
		self.isDone = todo.isDone
		self.text = todo.text
		self.inFocus = todo.inFocus
		self.isFavorite = todo.isFavorite
	}

	var todo: Todo {
		return .init(
			uuid: uuid,
			creationDate: creationDate,
			text: text,
			inFocus: inFocus,
			isFavorite: isFavorite,
			isDone: isDone
		)
	}
}
