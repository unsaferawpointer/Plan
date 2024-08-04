//
//  HierarchyTableAnimator.swift
//  Hierarchy
//
//  Created by Anton Cherkasov on 03.10.2023.
//

import Foundation

enum HierarchyAnimation {
	case remove(offset: Int, parent: UUID?)
	case insert(offset: Int, parent: UUID?)
	case reload(id: UUID?)
}

final class HierarchyAnimator {

	func calculate(old: HierarchySnapshot, new: HierarchySnapshot) -> (deleted: Set<UUID>, inserted: Set<UUID>) {
		return (deleted: old.identifiers.subtracting(new.identifiers),
				inserted: new.identifiers.subtracting(old.identifiers))
	}

	func calculate(
		old: HierarchySnapshot,
		new: HierarchySnapshot,
		animate: @escaping (HierarchyAnimation) -> Void
	) {

		calculate(in: nil, animate: animate) { parent in
			guard let parent else {
				return (old: old.root.map(\.id), new: new.root.map(\.id))
			}
			return (
				old: old.storage[unsafe: parent].map(\.id),
				new: new.storage[unsafe: parent].map(\.id)
			)
		}
	}

	func calculate(
		in parent: UUID?,
		animate: @escaping (HierarchyAnimation) -> Void,
		next: (UUID?) -> (old: [UUID], new: [UUID])
	) {

		var oldState = next(parent).old
		let newState = next(parent).new

		let difference = newState.difference(from: oldState)

		if !difference.isEmpty {
			animate(.reload(id: parent))
		}

		var removed = Set<UUID>()

		for change in difference {
			switch change {
			case let .remove(oldOffset, id, _):
				animate(.remove(offset: oldOffset, parent: parent))
				removed.insert(id)
			case let .insert(newOffset, id, _):
				animate(.insert(offset: newOffset, parent: parent))
				removed.remove(id)
			}
		}

		oldState.removeAll { removed.contains($0) }
		oldState.forEach { parent in
			calculate(in: parent, animate: animate, next: next)
		}
	}
}
