//
//  ListSorting+Extentions.swift
//  Plan
//
//  Created by Anton Cherkasov on 03.07.2023.
//

import Foundation

// MARK: - CoreDataSorting
extension ListSorting: CoreDataSorting {

	var sortDescriptor: NSSortDescriptor {
		switch self {
		case .creationDate(let ascending):
			return NSSortDescriptor(keyPath: \ListEntity.creationDate, ascending: ascending)
		case .isFavorite(let ascending):
			return NSSortDescriptor(keyPath: \ListEntity.isFavorite, ascending: ascending)
		case .name(let ascending):
			return NSSortDescriptor(keyPath: \ListEntity.name, ascending: ascending)
		case .tasksCount(let ascending):
			return NSSortDescriptor(keyPath: \ListEntity.tasks?.count, ascending: ascending)
		}
	}
}
