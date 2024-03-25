//
//  SidebarSettingsProvider.swift
//  Plan
//
//  Created by Anton Cherkasov on 24.03.2024.
//

import Foundation

protocol SidebarSettingsDelegate: AnyObject {
	func settingsDidChange()
}


protocol SidebarSettingsProviderProtocol {

	var selection: Route { get set }

	var delegate: SidebarSettingsDelegate? { get set }
}

final class SidebarSettingsProvider {

	weak var delegate: SidebarSettingsDelegate?

	private var appSettings: SettingsProviderProtocol

	private var settingsStorage: SettingsStorageProtocol

	// MARK: - Initialization

	init(
		appSettings: SettingsProviderProtocol,
		settingsStorage: SettingsStorageProtocol = SettingsStorage()
	) {
		self.appSettings = appSettings
		self.settingsStorage = settingsStorage
	}
}

// MARK: - SidebarSettingsProviderProtocol
extension SidebarSettingsProvider: SidebarSettingsProviderProtocol {

	var selection: Route {
		get {
			return appSettings.route
		}
		set {
			return appSettings.route = newValue
		}
	}
}
