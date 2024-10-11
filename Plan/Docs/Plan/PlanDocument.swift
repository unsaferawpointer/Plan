//
//  HierarchyDocument.swift
//  Hierarchy
//
//  Created by Anton Cherkasov on 27.09.2023.
//

import Cocoa

class PlanDocument: NSDocument {

	lazy var storage: DocumentStorage<PlanContent> = {
		return DocumentStorage<PlanContent>(
			initialState: .empty,
			provider: DataProvider(), 
			undoManager: undoManager
		)
	}()

	override init() {
		super.init()
	}

	override class var autosavesInPlace: Bool {
		return true
	}

	override func makeWindowControllers() {
		// Returns the Storyboard that contains your Document window.
		let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
		let windowController = storyboard.instantiateController(
			withIdentifier: NSStoryboard.SceneIdentifier("Document Window Controller")
		) as! NSWindowController
		windowController.window?.contentViewController = HierarchyAssembly.build(storage: storage)
		self.addWindowController(windowController)
	}

	override func data(ofType typeName: String) throws -> Data {
		return try storage.data(ofType: typeName)
	}

	override func read(from data: Data, ofType typeName: String) throws {
		try storage.read(from: data, ofType: typeName)
	}

}
