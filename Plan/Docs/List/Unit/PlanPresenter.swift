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

	weak var view: HierarchyView?

	var statusFactory: PlanStatusFactoryProtocol

	var modelFactory: PlanModelFactoryProtocol

	var localization: PlanLocalizationProtocol

	init(
		statusFactory: PlanStatusFactoryProtocol = PlanStatusFactory(),
		modelFactory: PlanModelFactoryProtocol = PlanModelFactory(),
		localization: PlanLocalizationProtocol = PlanLocalization()
	) {
		self.statusFactory = statusFactory
		self.modelFactory = modelFactory
		self.localization = localization
	}
}

extension PlanPresenter {

	var selection: [UUID] {
		return view?.selection ?? []
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
		view?.setConfiguration(
			DropConfiguration(types: [.id, .item, .string])
		)
		interactor?.fetchData()
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

	func setEstimation(_ value: Int) {
		interactor?.setEstimation(value, withSelection: selection)
	}

	func setIcon(_ value: String?) {
		interactor?.setIcon(value, withSelection: selection)
	}

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

	func fold() {
		view?.collapse(selection)
	}

	func unfold() {
		view?.expand(selection)
	}

	func paste() {
		let destination: HierarchyDestination<UUID> = {
			guard let first = selection.first else {
				return .toRoot
			}
			return .onItem(with: first)
		}()
		interactor?.insertFromPasteboard(to: destination)
	}

}

extension PlanPresenter {

	func makeModel(root: Root<ItemContent>) -> PlanModel {
		let snapshot = makeSnapshot(root)

		let status = statusFactory.makeModel(for: root)

		let model: PlanModel = if !snapshot.root.isEmpty {
			.regular(snapshot: snapshot, status: status)
		} else {
			.placeholder(
				title: "No Items, yet",
				subtitle: "Add a new element using the plus."
			)
		}
		return model
	}

	func makeSnapshot(_ root: Root<ItemContent>) -> HierarchySnapshot {
		let items = root.nodes
		return HierarchySnapshot(items) { item, info in
			modelFactory.makeModel(item: item, info: info)
		}
	}
}

// MARK: - HierarchyDropDelegate
extension PlanPresenter: HierarchyDropDelegate {

	func move(ids: [UUID], to destination: HierarchyDestination<UUID>) {
		interactor?.move(ids: ids, to: destination)
	}
	
	func validateMoving(ids: [UUID], to destination: HierarchyDestination<UUID>) -> Bool {
		return interactor?.validateMoving(ids: ids, to: destination) ?? false
	}
	
	func insert(_ nodes: [TransferNode], to destination: HierarchyDestination<UUID>) {
		interactor?.insert(nodes, to: destination)
	}

	func insert(_ texts: [String], to destination: HierarchyDestination<UUID>) {
		interactor?.insert(texts: texts, to: destination)
	}
}

// MARK: - ListItemViewOutput
extension PlanPresenter: ListItemViewOutput {

	func textfieldDidChange(_ id: UUID, newText: String) {
		interactor?.textDidChange(id, newText: newText)
	}

	func checkboxDidChange(_ id: UUID, newValue: Bool) {
		interactor?.statusDidChange(id, newValue: newValue)
	}
}
