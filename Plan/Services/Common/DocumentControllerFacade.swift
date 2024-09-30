//
//  DocumentControllerFacade.swift
//  Plan
//
//  Created by Anton Cherkasov on 30.09.2024.
//

import Cocoa

protocol DocumentControllerFacadeProtocol {
	func openRecentFile(withContentsOf url: URL)
}

final class DocumentController {

	private let documentController = NSDocumentController.shared

	private(set) var loadingTask: Task<Void, Never>?
}

// MARK: - DocumentControllerFacadeProtocol
extension DocumentController: DocumentControllerFacadeProtocol {

	func openRecentFile(withContentsOf url: URL) {
		loadingTask = Task { @MainActor in
			do {
				try await NSDocumentController.shared.openDocument(withContentsOf: url, display: true)
			} catch {
				NSApplication.shared.presentError(error)
			}
		}
	}
}
