//
//  TodoModel.swift
//  Plan
//
//  Created by Anton Cherkasov on 29.01.2024.
//

import Foundation

struct TodoModel {

	var uuid: UUID
	var isDone: Bool
	var isFavorite: Bool
	var text: String
	var listName: String?
	var creationDate: Date

}

// MARK: - Hashable
extension TodoModel: Hashable { }
