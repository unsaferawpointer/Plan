//
//  ProjectConfiguration.swift
//  Plan
//
//  Created by Anton Cherkasov on 27.01.2024.
//

import Foundation

struct ProjectConfiguration {

	var uuid: UUID

	var title: String

	var subtitle: String

	var countLabel: String?
}

// MARK: - Hashable
extension ProjectConfiguration: Hashable { }
