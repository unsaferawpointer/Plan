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

	// MARK: - Initialization

	/// Basic initialization
	///
	/// - Parameters:
	///    - router: App router
	init(router: Routable = AppRouter()) {
		self.router = router
	}
}

// MARK: - Coordinatable
extension Coordinator: Coordinatable {

	func start() {
		let sidebar = SidebarAssembly.assemble(self)
		let detail = TodosAssembly.assemble()
		router.showWindowAndOrderFront(sidebar: sidebar, detail: detail)
	}
}

// MARK: - SidebarOutput
extension Coordinator: SidebarOutput {

	func navigationDidChange(_ item: Route) {
		// TODO: - Hadle action
		switch item {
		case .focus:
			router.present(content: nil, detail: TodosAssembly.assemble())
		case .backlog:
			router.present(content: nil, detail: TodosAssembly.assemble())
		case .favorites:
			router.present(content: nil, detail: TodosAssembly.assemble())
		case .projects:
			router.present(content: ProjectsAssembly.assemble(), detail: TodosAssembly.assemble())
		}
	}
}
