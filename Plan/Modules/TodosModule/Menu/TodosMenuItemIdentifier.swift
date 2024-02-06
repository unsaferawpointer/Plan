//
//  TodosMenuItemIdentifier.swift
//  Plan
//
//  Created by Anton Cherkasov on 06.02.2024.
//

import Foundation

enum TodosMenuItemIdentifier {
	case new
	case complete
	case bookmark
	case focusOn
	case project(_ id: UUID)
	case delete
}
