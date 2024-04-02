//
//  List.swift
//  Plan
//
//  Created by Anton Cherkasov on 27.01.2024.
//

import Foundation

struct List {

	var uuid: UUID

	var title: String

	var isFavorite: Bool

	var count: Int
}

// MARK: - Hashable
extension List: Hashable { }
