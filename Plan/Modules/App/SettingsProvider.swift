//
//  SettingsProvider.swift
//  Plan
//
//  Created by Anton Cherkasov on 24.03.2024.
//

import Foundation

protocol SettingsProviderDelegate: AnyObject {
	func providerDidChangeSelection(newValue: Route)
}

protocol SettingsProviderProtocol {
	var route: Route { get set }
	var delegate: SettingsProviderDelegate? { get set }
}

final class SettingsProvider {

	weak var delegate: SettingsProviderDelegate?

	private var settingsStorage: SettingsStorageProtocol

	// MARK: - Internal state

	var _route: Route {
		didSet {
			delegate?.providerDidChangeSelection(newValue: _route)
			save()
		}
	}

	// MARK: - Initialization

	init(settingsStorage: SettingsStorageProtocol = SettingsStorage()) {
		self.settingsStorage = settingsStorage
		self._route = settingsStorage.getValue(type: Route.self, withKey: "sidebar_selection") ?? .inFocus
	}
}

// MARK: - SettingsProviderProtocol
extension SettingsProvider: SettingsProviderProtocol {

	var route: Route {
		get {
			_route
		}
		set {
			_route = newValue
		}
	}
}

// MARK: - Helpers
private extension SettingsProvider {

	func save() {
		settingsStorage.setValue(value: route, withKey: "sidebar_selection")
	}
}
