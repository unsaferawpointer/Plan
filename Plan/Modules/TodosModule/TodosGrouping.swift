//
//  TodosGrouping.swift
//  Plan
//
//  Created by Anton Cherkasov on 01.03.2024.
//

enum TodosGrouping: String {
	case none
	case list
	case priority
	case status
}

// MARK: - CaseIterable
extension TodosGrouping: CaseIterable { }
