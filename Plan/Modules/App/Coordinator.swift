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
		let sidebar = SidebarAssembly.assemble(stateProvider: stateProvider, titleDelegate: self)
		let detail = TodosAssembly.assemble(
			stateProvider: stateProvider,
			configuration: .inFocus,
			infoDelegate: self
		)
		router.showWindowAndOrderFront(sidebar: sidebar, detail: detail)
	}
}

// MARK: - StateProviderDelegate
extension Coordinator: StateProviderDelegate {

	func selectionDidChange(new: Selection, old: Selection) {
		guard new.route != old.route || new.projects != old.projects else {
			return
		}

		infoDidChange("")

		switch new.route {
		case .focus:
			presentDetail(with: .inFocus)
		case .backlog:
			presentDetail(with: .backlog)
		case .favorites:
			presentDetail(with: .favorites)
		case .archieve:
			presentDetail(with: .archieve)
		case .projects:
			guard let id = new.projects.first else {
				let detail = EmptyContentAssembly.assemble(.init(
					title: "No selection",
					subtitle: "Select a project.",
					image: "ghost")
				)
				let content = ProjectsAssembly.assemble(stateProvider: stateProvider)
				router.present(content: content, detail: detail)
				return
			}
			let detail = TodosAssembly.assemble(
				stateProvider: stateProvider,
				configuration: .project(id),
				infoDelegate: self
			)
			let content = ProjectsAssembly.assemble(stateProvider: stateProvider)
			router.present(content: content, detail: detail)
		}
	}
}

// MARK: - Helpers
private extension Coordinator {

	func presentDetail(with configuration: TodosConfiguration) {
		let detail = TodosAssembly.assemble(
			stateProvider: stateProvider,
			configuration: configuration,
			infoDelegate: self
		)
		router.present(content: nil, detail: detail)
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
