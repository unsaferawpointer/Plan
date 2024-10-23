//
//  ListUnitPresenter.swift
//  Plan
//
//  Created by Anton Cherkasov on 21.10.2024.
//

import Foundation

protocol ListUnitPresenterProtocol: AnyObject {
	func present(_ content: PlanContent)
}

final class ListUnitPresenter {

	var interactor: ListUnitInteractorProtocol?

	weak var view: ListView?

	private var modelsFactory = ListUnitViewModelFactory()

	private var columnsFactory: ListUnitColumnsFactoryProtocol

	// MARK: - Initialization

	init(
		columnsFactory: ListUnitColumnsFactoryProtocol = ListUnitColumnsFactory()
	) {
		self.columnsFactory = columnsFactory
	}
}

extension ListUnitPresenter {

	var selection: [UUID] {
		return view?.selection ?? []
	}
}

// MARK: - ListUnitPresenterProtocol
extension ListUnitPresenter: ListUnitPresenterProtocol {

	func present(_ content: PlanContent) {
		let snapshot = makeSnapshot(from: content)
		self.view?.display(.init(snapshot: snapshot))
	}
}

// MARK: - ListUnitViewOutput
extension ListUnitPresenter: ListUnitViewOutput {

	func viewDidLoad() {
		let columns = columnsFactory.makeColumns(delegate: self)

		view?.setConfiguration(columns)
		interactor?.fetchData()
	}
	
	func deleteItems() {
		fatalError()
	}
	
	func createNew() {
		fatalError()
	}
	
	func setState(_ flag: Bool) {
		interactor?.setState(flag, withSelection: selection)
	}
	
	func setBookmark(_ flag: Bool) {
		interactor?.setBookmark(flag, withSelection: selection)
	}
	
	func setEstimation(_ value: Int) {
		fatalError()
	}
	
	func setPriority(_ value: Int) {
		fatalError()
	}
	
	func setIcon(_ value: IconName?) {
		fatalError()
	}
	
	func setColor(_ value: Color?) {
		fatalError()
	}

	func canUndo() -> Bool {
		fatalError()
	}
	
	func canRedo() -> Bool {
		fatalError()
	}
	
	func redo() {
		fatalError()
	}
	
	func undo() {
		fatalError()
	}
}

// MARK: - PlanColumnsFactoryDelegate
extension ListUnitPresenter: ListUnitColumnsFactoryDelegate {

	func modificated(id: UUID, newText: String) {
		interactor?.modificate(id, newText: newText)
	}

	func modificate(id: UUID, newStatus: Bool) {
		interactor?.modificate(id, newStatus: newStatus)
	}

	func modificate(id: UUID, value: Int) {
		interactor?.setNumber(value, withSelection: selection)
	}
}

private extension ListUnitPresenter {

	func makeSnapshot(from content: PlanContent) -> ListSnapshot<ListItemViewModel> {
		var models = [ListItemViewModel]()
		content.hierarchy.enumerate { node in
			guard node.children.isEmpty else {
				return
			}
			models.append(modelsFactory.makeModel(item: node.value))
		}
		return .init(items: models)
	}
}
