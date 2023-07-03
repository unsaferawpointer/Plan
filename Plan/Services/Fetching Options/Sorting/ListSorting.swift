//
//  ListSorting.swift
//  Plan
//
//  Created by Anton Cherkasov on 11.06.2023.
//

enum ListSorting {
	case creationDate(ascending: Bool = true)
	case isFavorite(ascending: Bool = true)
	case name(ascending: Bool = true)
	case tasksCount(ascending: Bool = true)
}
