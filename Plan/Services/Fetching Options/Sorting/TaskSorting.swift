//
//  TaskSorting.swift
//  Plan
//
//  Created by Anton Cherkasov on 11.06.2023.
//

enum TaskSorting {
	case creationDate(ascending: Bool = true)
	case text(ascending: Bool = true)
	case status(ascending: Bool = true)
}
