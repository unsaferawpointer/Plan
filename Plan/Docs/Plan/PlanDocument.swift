//
//  HierarchyDocument.swift
//  Hierarchy
//
//  Created by Anton Cherkasov on 27.09.2023.
//

import Cocoa
import SwiftUI

class PlanDocument: NSDocument {

	lazy var storage: DocumentStorage<PlanContent> = {
		return DocumentStorage<PlanContent>(
			initialState: .empty,
			provider: PlanDataProvider(), 
			undoManager: undoManager
		)
	}()

	lazy var stateProvider: AnyStateProvider<PlanDocumentState> = {
		return .init(initialState: PlanDocumentState())
	}()

	override init() {
		super.init()
	}

	override class var autosavesInPlace: Bool {
		return true
	}

	override func makeWindowControllers() {
		// Returns the Storyboard that contains your Document window.
		let window = NSWindow.makeMain()
		let windowController = DocumentWindowController(window: window)
		windowController.window?.contentViewController = HierarchyAssembly.build(
			storage: storage,
			provider: stateProvider
		)

		self.addWindowController(windowController)
	}

	override func data(ofType typeName: String) throws -> Data {
		return try storage.data(ofType: typeName)
	}

	override func read(from data: Data, ofType typeName: String) throws {
		try storage.read(from: data, ofType: typeName)
	}

}

// MARK: - Helpers
private extension PlanDocument {

	func makeContentViewController() -> NSViewController {

		let viewController = NSSplitViewController()
		let sidebarViewController = NSHostingController(
			rootView: SidebarView(
				viewModel: SidebarViewModel(provider: stateProvider, storage: storage)
			)
		)

		let sidebarItem = NSSplitViewItem(sidebarWithViewController: sidebarViewController)
		let contentItem = NSSplitViewItem(
			viewController: HierarchyAssembly.build(
				storage: storage,
				provider: stateProvider
			)
		)

		stateProvider.addObservation(for: self) { _, state in
			Swift.print("state = \(state)")
		}

		viewController.addSplitViewItem(sidebarItem)
		viewController.addSplitViewItem(contentItem)

		return viewController
	}
}
