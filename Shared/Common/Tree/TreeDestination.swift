//
//  HierarchyDestination.swift
//  Hierarchy
//
//  Created by Anton Cherkasov on 07.10.2023.
//

import Foundation

enum HierarchyDestination<ID> {

	case toRoot
	case inRoot(atIndex: Int)
	case onItem(with: ID)
	case inItem(with: ID, atIndex: Int)

	var id: ID? {
		switch self {
		case .toRoot, .inRoot:
			return nil
		case .onItem(let id), .inItem(let id, _):
			return id
		}
	}

	var index: Int? {
		switch self {
		case .toRoot:
			return nil
		case .inRoot(let index):
			return index
		case .onItem:
			return nil
		case .inItem(_ , let index):
			return index
		}
	}

	// MARK: - Initialization block

	init(target: ID?) {
		if let target {
			self = .onItem(with: target)
		} else {
			self = .toRoot
		}
	}
}

extension HierarchyDestination {

	func relative(to root: ID?) -> HierarchyDestination<ID> {
		guard let root else {
			return self
		}

		switch self {
		case .toRoot:
			return .onItem(with: root)
		case .inRoot(let index):
			return .inItem(with: root, atIndex: index)
		default:
			return self
		}
	}
}
