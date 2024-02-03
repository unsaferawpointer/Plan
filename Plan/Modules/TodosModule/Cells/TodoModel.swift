//
//  TodoModel.swift
//  Plan
//
//  Created by Anton Cherkasov on 29.01.2024.
//

import Foundation

struct TodoModel: ViewConfiguration {

	typealias View = TodoCell

	var uuid: UUID
	var isDone: Bool
	var isFavorite: Bool
	var inFocus: Bool
	var text: String

}

// MARK: - Hashable
extension TodoModel: Hashable { }
