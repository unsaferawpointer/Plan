//
//  ProjectSorting.swift
//  Plan
//
//  Created by Anton Cherkasov on 11.06.2023.
//

enum ProjectSorting {
	case creationDate(ascending: Bool = true)
	case name(ascending: Bool = true)
}

// MARK: - Hashable
extension ProjectSorting: Hashable { }
