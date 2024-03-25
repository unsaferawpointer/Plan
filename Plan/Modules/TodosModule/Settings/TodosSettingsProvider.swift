//
//  TodosSettingsProvider.swift
//  Plan
//
//  Created by Anton Cherkasov on 10.03.2024.
//

import Foundation

protocol TodosSettingsDelegate: AnyObject {
	func settingsDidChange()
}

protocol TodosSettingsProviderProtocol {

	func getGrouping(for behaviour: Behaviour) -> TodosGrouping

	func setGrouping(_ grouping: TodosGrouping, for behaviour: Behaviour)

	var delegate: TodosSettingsDelegate? { get set }
}

final class TodosSettingsProvider {

	weak var delegate: TodosSettingsDelegate?

	private var settingsStorage: SettingsStorageProtocol

	// MARK: - Initialization

	init(settingsStorage: SettingsStorageProtocol = SettingsStorage()) {
		self.settingsStorage = settingsStorage
	}
}

// MARK: - TodosSettingsProviderProtocol
extension TodosSettingsProvider: TodosSettingsProviderProtocol {

	func getGrouping(for behaviour: Behaviour) -> TodosGrouping {
		let key = key(for: behaviour)
		return settingsStorage.getValue(type: TodosGrouping.self, withKey: key) ?? .none
	}
	
	func setGrouping(_ grouping: TodosGrouping, for behaviour: Behaviour) {
		let key = key(for: behaviour)
		settingsStorage.setValue(value: grouping, withKey: key)
		delegate?.settingsDidChange()
	}
}

// MARK: - Helpers
private extension TodosSettingsProvider {

	func key(for behaviour: Behaviour) -> String {
		switch behaviour {
		case .inFocus:	return Keys.inFocusGrouping
		case .backlog:	return Keys.backlogGrouping
		case .archieve:	return Keys.archieveGrouping
		case .list:		return Keys.listGrouping
		}
	}
}

// MARK: - Nested data structs
extension TodosSettingsProvider {

	struct Keys {
		static let inFocusGrouping = "inFocus_grouping"
		static let backlogGrouping = "backlog_grouping"
		static let archieveGrouping = "archieve_grouping"
		static let listGrouping = "list_grouping"
	}
}
