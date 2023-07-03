//
//  TaskSorting+Extentions.swift
//  Plan
//
//  Created by Anton Cherkasov on 03.07.2023.
//

import Foundation

// MARK: - CoreDataSorting
extension TaskSorting: CoreDataSorting {

	var sortDescriptor: NSSortDescriptor {
		switch self {
		case .creationDate(let ascending):
			return NSSortDescriptor(keyPath: \TaskEntity.creationDate, ascending: ascending)
		case .text(let ascending):
			return NSSortDescriptor(keyPath: \TaskEntity.text, ascending: ascending)
		case .status(ascending: let ascending):
			return NSSortDescriptor(keyPath: \TaskEntity.status, ascending: ascending)
		}
	}
}
