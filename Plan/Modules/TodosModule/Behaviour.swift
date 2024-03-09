//
//  Behaviour.swift
//  Plan
//
//  Created by Anton Cherkasov on 09.03.2024.
//

import Foundation

enum Behaviour {
	case inFocus
	case backlog
	case archieve
	case list(_ id: UUID)
}
