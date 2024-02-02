//
//  Coordinator.swift
//  Plan
//
//  Created by Anton Cherkasov on 27.01.2024.
//

import Cocoa

typealias StateProviderProtocol = SidebarStateProviderProtocol & ProjectsStateProviderProtocol & TodosStateProviderProtocol

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
		let sidebar = SidebarAssembly.assemble(stateProvider: stateProvider)
		let detail = TodosAssembly.assemble(stateProvider: stateProvider, configuration: .inFocus)
		router.showWindowAndOrderFront(sidebar: sidebar, detail: detail)
	}
}

// MARK: - StateProviderDelegate
extension Coordinator: StateProviderDelegate {

	func providerDidChangeState(_ state: State) {

		switch state.selection.route {
		case .focus:
			let detail = TodosAssembly.assemble(stateProvider: stateProvider, configuration: .inFocus)
			router.present(content: nil, detail: detail)
		case .backlog:
			let detail = TodosAssembly.assemble(stateProvider: stateProvider, configuration: .backlog)
			router.present(content: nil, detail: detail)
		case .favorites:
			let detail = TodosAssembly.assemble(stateProvider: stateProvider, configuration: .favorites)
			router.present(content: nil, detail: detail)
		case .projects:
			let detail = TodosAssembly.assemble(stateProvider: stateProvider, configuration: .backlog)
			let content = ProjectsAssembly.assemble(stateProvider: stateProvider)
			router.present(content: content, detail: detail)
		}
	}
}
