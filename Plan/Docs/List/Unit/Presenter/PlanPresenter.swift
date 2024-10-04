//
//  PlanPresenter.swift
//  Hierarchy
//
//  Created by Anton Cherkasov on 02.10.2023.
//

import Foundation

protocol ListPresenterProtocol: AnyObject {
	func present(_ content: HierarchyContent)
}

final class PlanPresenter {

	var interactor: PlanInteractorProtocol?

	weak var view: PlanView?

	private var statusFactory: PlanStatusFactoryProtocol

	private var modelFactory: PlanModelFactoryProtocol

	private var columnsFactory: PlanColumnsFactoryProtocol

	private var localization: PlanLocalizationProtocol

	var pasteboard: PlanPasteboardProtocol

	var generalPasteboard: PasteboardFacadeProtocol

	// MARK: - Initialization

	init(
		statusFactory: PlanStatusFactoryProtocol = PlanStatusFactory(),
		modelFactory: PlanModelFactoryProtocol = PlanModelFactory(),
		columnsFactory: PlanColumnsFactoryProtocol = PlanColumnsFactory(),
		localization: PlanLocalizationProtocol = PlanLocalization(),
		pasteboard: PlanPasteboardProtocol = PlanPasteboard(),
		generalPasteboard: PasteboardFacadeProtocol = PasteboardFacade(pasteboard: .general)
	) {
		self.statusFactory = statusFactory
		self.modelFactory = modelFactory
		self.columnsFactory = columnsFactory
		self.localization = localization
		self.pasteboard = pasteboard
		self.generalPasteboard = generalPasteboard
	}
}

// MARK: - Computed properties
extension PlanPresenter {

	var selection: [UUID] {
		return view?.selection ?? []
	}

	var destination: HierarchyDestination<UUID> {
		return if let first = selection.first {
			.onItem(with: first)
		} else {
			.toRoot
		}
	}
}

// MARK: - ListPresenterProtocol
extension PlanPresenter: ListPresenterProtocol {

	func present(_ content: HierarchyContent) {
		let model = makeModel(root: content.hierarchy)
		self.view?.display(model)
	}
}

// MARK: - ListPresenterProtocol
extension PlanPresenter: PlanViewOutput {

	func viewDidLoad() {

		let columns = columnsFactory.makeColumns(delegate: self)

		view?.setConfiguration(columns)
		view?.setConfiguration(
			DropConfiguration(types: [.id, .item, .string])
		)
		interactor?.fetchData()
		view?.expandAll()
	}

	func deleteItems() {
		interactor?.deleteItems(selection)
	}

	func createNew() {
		guard let interactor else {
			return
		}

		let first = selection.first
		let id = interactor.createNew(with: localization.newItemTitle, in: first)

		view?.scroll(to: id)
		if let first {
			view?.expand([first])
		}
		view?.focus(on: id)
	}

	func setState(_ flag: Bool) {
		interactor?.setState(flag, withSelection: selection)
	}

	func setBookmark(_ flag: Bool) {
		interactor?.setBookmark(flag, withSelection: selection)
	}

	func setPriority(_ value: Int) {
		guard let priority = ItemPriority(rawValue: value) else {
			return
		}
		interactor?.setPriority(priority, withSelection: selection)
	}

	func setEstimation(_ value: Int) {
		interactor?.setNumber(value, withSelection: selection)
	}

	func setIcon(_ value: IconName?) {
		interactor?.setIcon(value, withSelection: selection)
	}

	func fold() {
		view?.collapse(selection)
	}

	func unfold() {
		view?.expand(selection)
	}
}

// MARK: - UndoManagerSupportable
extension PlanPresenter: UndoManagerSupportable {

	func canUndo() -> Bool {
		interactor?.canUndo() ?? false
	}

	func canRedo() -> Bool {
		interactor?.canRedo() ?? false
	}

	func redo() {
		interactor?.redo()
	}

	func undo() {
		interactor?.undo()
	}
}

// MARK: - PasteboardSupportable
extension PlanPresenter: PasteboardSupportable {

	func cut() {
		guard let nodes = interactor?.nodes(selection) else {
			return
		}
		pasteboard.write(
			nodes,
			to: generalPasteboard,
			clearContents: true
		)
		interactor?.deleteItems(selection)
	}

	func paste() {
		let nodes = pasteboard.readNodes(from: generalPasteboard)

		guard !nodes.isEmpty else {

			let texts = pasteboard.readTexts(from: generalPasteboard)
			interactor?.insert(texts: texts, to: destination)
			return
		}
		interactor?.insert(nodes, to: destination)
	}

	func canPaste() -> Bool {
		return pasteboard.contains(
			types: [.string, .item],
			in: generalPasteboard
		)
	}

	func copy() {
		guard let nodes = interactor?.nodes(selection) else {
			return
		}
		pasteboard.write(
			nodes,
			to: generalPasteboard,
			clearContents: true
		)
	}
}

// MARK: - PlanColumnsFactoryDelegate
extension PlanPresenter: PlanColumnsFactoryDelegate {

	func modificate(id: UUID, newText: String, newStatus: Bool?) {
		let trimmed = newText.trimmingCharacters(in: .whitespacesAndNewlines)
		guard !trimmed.isEmpty else {
			interactor?.deleteItems([id])
			return
		}
		if let isOn = newStatus {
			interactor?.modificate(id, newText: trimmed, newStatus: isOn)
		} else {
			interactor?.modificate(id, newText: trimmed)
		}
	}

	func modificate(id: UUID, value: Int) {
		interactor?.setNumber(value, withSelection: selection)
	}
}

// MARK: - Helpers
private extension PlanPresenter {

	func makeModel(root: Root<ItemContent>) -> PlanModel {

		let snapshot = makeSnapshot(root)
		let status = statusFactory.makeModel(for: root)

		return PlanModel(bottomBar: status, snapshot: snapshot)
	}

	func makeSnapshot(_ root: Root<ItemContent>) -> HierarchySnapshot {
		let items = root.nodes
		return HierarchySnapshot(items) { item, info in
			return modelFactory.makeModel(item: item, info: info)
		}
	}
}
