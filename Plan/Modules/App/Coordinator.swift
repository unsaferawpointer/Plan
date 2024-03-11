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

	func quit()

	func showAboutPanel()
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
			infoDelegate: self,
			behaviour: .inFocus
		)
		router.showWindowAndOrderFront(sidebar: sidebar, detail: detail)
	}

	func quit() {
		NSApplication.shared.terminate(nil)
	}

	func showAboutPanel() {
		NSApp.orderFrontStandardAboutPanel()
	}
}

// MARK: - StateProviderDelegate
extension Coordinator: StateProviderDelegate {

	func selectionDidChange(new: Selection, old: Selection) {
		guard new.route != old.route else {
			return
		}

		infoDidChange("")

		let behaviour = new.route.behaviour

		let detail = TodosAssembly.assemble(
			stateProvider: stateProvider,
			infoDelegate: self,
			behaviour: behaviour
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

extension Route {

	var behaviour: Behaviour {
		switch self {
		case .inFocus:
			return .inFocus
		case .backlog:
			return .backlog
		case .archieve:
			return .archieve
		case .list(let id):
			return .list(id)
		}
	}
}
