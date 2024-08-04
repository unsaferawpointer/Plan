//
//  DropConfiguration.swift
//  Hierarchy
//
//  Created by Anton Cherkasov on 04.10.2023.
//

import Cocoa

struct DropConfiguration {

	var types: [NSPasteboard.PasteboardType] = []

	var onMove: (([UUID], HierarchyDestination<UUID>) -> Void)?

	var invalidateMoving: (([UUID], HierarchyDestination<UUID>) -> Bool)?

	var onInsert: (([TransferNode], HierarchyDestination<UUID>) -> Void)?
}
