//
//  Route.swift
//  Plan
//
//  Created by Anton Cherkasov on 27.01.2024.
//

import Foundation

enum Route {
	case inFocus
	case backlog
	case archieve
	case list(_ id: UUID)
}

// MARK: - Hashable
extension Route: Hashable { }

// MARK: - RawRepresentable
extension Route: RawRepresentable {

	init?(rawValue: String) {
		switch rawValue {
		case "inFocus":
			self = .inFocus
		case "backlog":
			self = .backlog
		case "archieve":
			self = .archieve
		default:
			let components = rawValue.split(separator: "_")
			guard
				components.count == 2,
				let key = components.first, key == "list",
				let uuidString = components.last, let uuid = UUID(uuidString: String(uuidString))
			else {
				return nil
			}
			self = .list(uuid)
		}
	}

	var rawValue: String {
		switch self {
		case .inFocus:
			return "inFocus"
		case .backlog:
			return "backlog"
		case .archieve:
			return "archieve"
		case .list(let id):
			return "list" + "_" + id.uuidString
		}
	}
}
