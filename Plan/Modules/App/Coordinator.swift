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

	private (set) var settingsProvider: SettingsProviderProtocol

	// MARK: - Initialization

	/// Basic initialization
	///
	/// - Parameters:
	///    - router: App router
	init(
		router: Routable = AppRouter(),
		settingsProvider: SettingsProviderProtocol = SettingsProvider(settingsStorage: SettingsStorage())
	) {
		self.router = router
		self.settingsProvider = settingsProvider
		self.settingsProvider.delegate = self
	}
}

// MARK: - Coordinatable
extension Coordinator: Coordinatable {

	func start() {
		let sidebar = SidebarAssembly.assemble(
			settingsProvider: SidebarSettingsProvider(appSettings: settingsProvider),
			titleDelegate: self
		)
		let detail = TodosAssembly.assemble(
			settingsProvider: TodosSettingsProvider(settingsStorage: SettingsStorage()),
			infoDelegate: self,
			behaviour: settingsProvider.route.behaviour
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

// MARK: - SettingsProviderDelegate
extension Coordinator: SettingsProviderDelegate {

	func providerDidChangeSelection(newValue: Route) {
		infoDidChange("")

		let behaviour = newValue.behaviour

		let detail = TodosAssembly.assemble(
			settingsProvider: TodosSettingsProvider(settingsStorage: SettingsStorage()),
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
