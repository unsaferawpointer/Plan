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

	private var statusFactory: PlanStatusFactoryProtocol

	private var modelFactory: PlanModelFactoryProtocol

	private var localization: PlanLocalizationProtocol

	private (set) var formatter: BasicFormatterProtocol

	init(
		statusFactory: PlanStatusFactoryProtocol = PlanStatusFactory(),
		modelFactory: PlanModelFactoryProtocol = PlanModelFactory(),
		localization: PlanLocalizationProtocol = PlanLocalization(),
		formatter: BasicFormatterProtocol = BasicFormatter()
	) {
		self.statusFactory = statusFactory
		self.modelFactory = modelFactory
		self.localization = localization
		self.formatter = formatter
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

		let dateCreated = AnyColumn<HierarchyModel, TextCell>(
			identifier: "created_date_table_column",
			title: localization.createdDateColumnTitle,
			keyPath: \.createdAt,
			options: .init(minWidth: 200, maxWidth: 240, isRequired: false, isHidden: true)
		)

		let dateCompleted = AnyColumn<HierarchyModel, TextCell>(
			identifier: "completed_date_table_column",
			title: localization.completedDateColumnTitle,
			keyPath: \.completedAt,
			options: .init(minWidth: 200, maxWidth: 240, isRequired: false, isHidden: true)
		)

		let main = AnyColumn<HierarchyModel, PlanItemCell>(
			identifier: "description_table_column",
			title: localization.descriptionColumnTitle,
			keyPath: \.content,
			options: .init(minWidth: 320, maxWidth: nil, isRequired: true, isHidden: false)) { [weak self] id, value in
				self?.modificate(id: id, newText: value.text, newStatus: value.isOn)
			}

		let estimation = AnyColumn<HierarchyModel, BadgeCell>(
			identifier: "estimation_table_column",
			title: localization.estimationColumnTitle,
			keyPath: \.badge,
			options: .init(minWidth: 56, maxWidth: 72, isRequired: false, isHidden: false)
		)

		view?.setConfiguration([main, estimation, dateCreated, dateCompleted])
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

	func setEstimation(_ value: Int) {
		interactor?.setEstimation(value, withSelection: selection)
	}

	func setIcon(_ value: IconName?) {
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

	func copy() {
		interactor?.copyToPasteboard(selection)
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

// MARK: - Helpers
private extension PlanPresenter {

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
}
