//
//  TodosConfiguration.swift
//  Plan
//
//  Created by Anton Cherkasov on 02.02.2024.
//

import Foundation

enum TodosConfiguration {

	case inFocus
	case backlog
	case favorites
	case project(_ id: UUID)
	case archieve
}
