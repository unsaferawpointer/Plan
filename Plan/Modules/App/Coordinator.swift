//
//  Coordinator.swift
//  Plan
//
//  Created by Anton Cherkasov on 27.01.2024.
//

import Cocoa

/// Interface of the coordinator
protocol Coordinatable {

	/// Start flow
	func start()
}

/// App coordinator
final class Coordinator {

	private (set) var router: Routable

	private (set) var stateProvider: StateProviderProtocol

	// MARK: - Initialization

	/// Basic initialization
	///
	/// - Parameters:
	///    - router: App router
	init(router: Routable = AppRouter()) {
		self.router = router
		let stateProvider = StateProvider()
		self.stateProvider = stateProvider

		stateProvider.delegate = self
	}
}

// MARK: - Coordinatable
extension Coordinator: Coordinatable {

	func start() {
		let sidebar = SidebarAssembly.assemble(stateProvider: stateProvider, titleDelegate: self)
		let detail = TodosAssembly.assemble(
			stateProvider: stateProvider,
			predicate: .inProgress,
			infoDelegate: self,
			grouping: .list, 
			order: [.isFavorite, .isDone, .creationDate]
		)
		router.showWindowAndOrderFront(sidebar: sidebar, detail: detail)
	}
}

// MARK: - StateProviderDelegate
extension Coordinator: StateProviderDelegate {

	func selectionDidChange(new: Selection, old: Selection) {
		guard new.route != old.route else {
			return
		}

		infoDidChange("")

		switch new.route {
		case .inbox:
			presentDetail(with: .inProgress, grouping: .list, order: [.isFavorite, .creationDate])
		case .backlog:
			presentDetail(with: .backlog, grouping: .none, order: [.isFavorite, .creationDate])
		case .favorites:
			presentDetail(with: .isFavorite, grouping: .none, order: [.isFavorite, .creationDate])
		case .archieve:
			presentDetail(with: .isDone, grouping: .none, order: [.completionDate, .creationDate])
		case .list(let id):
			let detail = TodosAssembly.assemble(
				stateProvider: stateProvider,
				predicate: .list(id),
				infoDelegate: self,
				grouping: .none, 
				order: [.isFavorite, .isDone, .creationDate]
			)
			router.present(detail: detail)
		}
	}
}

// MARK: - Helpers
private extension Coordinator {

	func presentDetail(with predicate: TodosPredicate, grouping: TodosGrouping, order: [TodosOrder]) {
		let detail = TodosAssembly.assemble(
			stateProvider: stateProvider,
			predicate: predicate,
			infoDelegate: self, 
			grouping: grouping,
			order: order
		)
		router.present(detail: detail)
	}
}

// MARK: - SubtitleInfoProvider
extension Coordinator: InfoDelegate {

	func infoDidChange(_ info: String) {
		router.setWindow(title: nil, subtitle: info)
	}
}

// MARK: - TitleDelegate
extension Coordinator: TitleDelegate {

	func titleDidChange(_ title: String) {
		router.setWindow(title: title, subtitle: nil)
	}
}
