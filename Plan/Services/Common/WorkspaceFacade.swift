//
//  WorkspaceFacadeswift.swift
//  Plan
//
//  Created by Anton Cherkasov on 30.09.2024.
//

import Cocoa

protocol WorkspaceFacadeProtocol {
	func image(forFile file: URL) -> NSImage
}

final class WorkspaceFacade { }

// MARK: - WorkspaceFacadeProtocol
extension WorkspaceFacade: WorkspaceFacadeProtocol {

	func image(forFile file: URL) -> NSImage {
		NSWorkspace.shared.icon(forFile: file.path)
	}
}
