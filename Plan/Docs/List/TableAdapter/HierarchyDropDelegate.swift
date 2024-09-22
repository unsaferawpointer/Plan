//
//  HierarchyDropDelegate.swift
//  Plan
//
//  Created by Anton Cherkasov on 06.08.2024.
//

import Foundation

protocol HierarchyDropDelegate: AnyObject {

	func move(ids: [UUID], to destination: HierarchyDestination<UUID>)

	func validateMoving(ids: [UUID], to destination: HierarchyDestination<UUID>) -> Bool

	func insert(from pasteboard: PasteboardFacadeProtocol, to destination: HierarchyDestination<UUID>)

	func write(ids: [UUID], to pasteboard: PasteboardFacadeProtocol)
}
