//
//  TodosGrouping.swift
//  Plan
//
//  Created by Anton Cherkasov on 01.03.2024.
//

enum TodosGrouping {
	case none
	case list
	case urgency
	case status
}

// MARK: - CaseIterable
extension TodosGrouping: CaseIterable { }
