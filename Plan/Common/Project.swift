//
//  Project.swift
//  Plan
//
//  Created by Anton Cherkasov on 27.01.2024.
//

import Foundation

struct Project {

	var uuid: UUID

	var title: String

	var count: Int
}

// MARK: - Hashable
extension Project: Hashable { }
