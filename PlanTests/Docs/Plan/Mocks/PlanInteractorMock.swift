//
//  PlanInteractorMock.swift
//  PlanTests
//
//  Created by Anton Cherkasov on 31.08.2024.
//

import Foundation
@testable import Plan

final class PlanInteractorMock {
	var invocations: [Action] = []
	var stubs = Stubs()
}

// MARK: - HierarchyInteractorProtocol
extension PlanInteractorMock: HierarchyInteractorProtocol {

	func fetchData() {
		invocations.append(.fetchData)
	}
	
	func node(_ id: UUID) -> any TreeNode<ItemContent> {
		invocations.append(.node(id))
		guard let stub = stubs.node else {
			fatalError()
		}
		return stub
	}

	func nodes(_ ids: [UUID]) -> [any TreeNode<ItemContent>] {
		invocations.append(.nodes(ids))
		return stubs.nodes
	}

	func createNew(with text: String, in target: UUID?) -> UUID {
		invocations.append(.createNew(text: text, target: target))
		return stubs.createNew
	}
	
	func deleteItems(_ ids: [UUID]) {
		invocations.append(.deleteItems(ids))
	}
	
	func setState(_ flag: Bool, withSelection selection: [UUID]) {
		invocations.append(.setState(flag, selection: selection))
	}
	
	func setBookmark(_ flag: Bool, withSelection selection: [UUID]) {
		invocations.append(.setBookmark(flag, selection: selection))
	}
	
	func setNumber(_ value: Int, withSelection selection: [UUID]) {
		invocations.append(.setEstimation(value, selection: selection))
	}
	
	func setIcon(_ value: IconName?, withSelection selection: [UUID]) {
		invocations.append(.setIcon(value, selection: selection))
	}

	func setColor(_ value: Plan.Color?, withSelection selection: [UUID]) {
		invocations.append(.setColor(value, selection: selection))
	}

	func move(ids: [UUID], to destination: HierarchyDestination<UUID>) {
		invocations.append(.move(ids: ids, destination: destination))
	}
	
	func validateMoving(ids: [UUID], to destination: HierarchyDestination<UUID>) -> Bool {
		invocations.append(.validateMoving(ids: ids, destination: destination))
		return stubs.validateMoving
	}

	func insert(_ nodes: [any TreeNode<ItemContent>], to destination: Plan.HierarchyDestination<UUID>) {
		invocations.append(.insertNodes(nodes, destination: destination))
	}

	func insert(texts: [String], to destination: HierarchyDestination<UUID>) {
		invocations.append(.insertTexts(texts: texts, destination: destination))
	}

	func modificate(_ id: UUID, newText: String, newStatus: Bool) {
		invocations.append(.modificate(id, newText: newText, newStatus: newStatus))
	}
	
	func modificate(_ id: UUID, newText: String) {
		invocations.append(.modificate(id, newText: newText))
	}
	
	func canUndo() -> Bool {
		invocations.append(.canRedo)
		return stubs.canUndo
	}
	
	func canRedo() -> Bool {
		invocations.append(.canRedo)
		return stubs.canRedo
	}
	
	func redo() {
		invocations.append(.redo)
	}
	
	func undo() {
		invocations.append(.undo)
	}
	
	func insertFromPasteboard(to destination: HierarchyDestination<UUID>) {
		invocations.append(.insertFromPasteboard(destination: destination))
	}
	
	func copyToPasteboard(_ ids: [UUID]) {
		invocations.append(.copyToPasteboard(ids))
	}

	func setPriority(_ value: ItemPriority, withSelection selection: [UUID]) {
		invocations.append(.setPriority(value: value, selection: selection))
	}
}

// MARK: - Nested data structs
extension PlanInteractorMock {

	enum Action {
		case fetchData
		case node(_ id: UUID)
		case nodes(_ ids: [UUID])
		case createNew(text: String, target: UUID?)
		case deleteItems(_ ids: [UUID])
		case setState(_ flag: Bool, selection: [UUID])
		case setBookmark(_ flag: Bool, selection: [UUID])
		case setEstimation(_ value: Int, selection: [UUID])
		case setIcon(_ value: IconName?, selection: [UUID])
		case setColor(_ value: Color?, selection: [UUID])
		case move(ids: [UUID], destination: HierarchyDestination<UUID>)
		case validateMoving(ids: [UUID], destination: HierarchyDestination<UUID>)
		case insertNodes(_ nodes: [any TreeNode<ItemContent>], destination: HierarchyDestination<UUID>)
		case insertTexts(texts: [String], destination: HierarchyDestination<UUID>)
		case modificate(_ id: UUID, newText: String, newStatus: Bool)
		case modificate(_ id: UUID, newText: String)
		case canUndo
		case canRedo
		case redo
		case undo
		case insertFromPasteboard(destination: HierarchyDestination<UUID>)
		case copyToPasteboard(_ ids: [UUID])
		case setPriority(value: ItemPriority, selection: [UUID])
	}

	struct Stubs {
		var node: (any TreeNode<ItemContent>)?
		var nodes: [any TreeNode<ItemContent>] = []
		var createNew = UUID()
		var validateMoving: Bool = false
		var canUndo: Bool = false
		var canRedo: Bool = false
	}
}
