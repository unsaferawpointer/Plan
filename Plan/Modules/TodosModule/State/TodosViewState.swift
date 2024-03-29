//
//  TodosViewState.swift
//  Plan
//
//  Created by Anton Cherkasov on 04.02.2024.
//

import Foundation

enum TodosViewState {
	case placeholder(title: String, subtitle: String, image: String)
	case content(items: [TableItem])
}

// MARK: - Equatable
extension TodosViewState: Equatable { }
