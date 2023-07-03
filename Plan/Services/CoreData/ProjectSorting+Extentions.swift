//
//  ProjectSorting+Extentions.swift
//  Plan
//
//  Created by Anton Cherkasov on 03.07.2023.
//

import Foundation

// MARK: - CoreDataSorting
extension ProjectSorting: CoreDataSorting {

	var sortDescriptor: NSSortDescriptor {
		switch self {
		case .creationDate(let ascending):
			return NSSortDescriptor(keyPath: \ProjectEntity.creationDate, ascending: ascending)
		case .name(let ascending):
			return NSSortDescriptor(keyPath: \ProjectEntity.name, ascending: ascending)
		}
	}
}
