//
//  TaskItem.swift
//  Plan
//
//  Created by Anton Cherkasov on 10.06.2023.
//

import Foundation

struct TaskItem {

	var uuid: UUID

	var status: TaskStatus

	var text: String

	var creationDate: Date

	// MARK: - Initialization

	/// Basic initialization
	init(uuid: UUID = UUID(), status: TaskStatus, text: String, creationDate: Date = Date()) {
		self.uuid = uuid
		self.status = status
		self.text = text
		self.creationDate = creationDate
	}

}

// MARK: - Hashable
extension TaskItem: Hashable { }

/// Task status
enum TaskStatus: Int16 {
	case incomplete = 0
	case done = 1
}
