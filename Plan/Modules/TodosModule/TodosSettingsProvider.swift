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
}

// MARK: - TodosSettingsProviderProtocol
extension TodosSettingsProvider: TodosSettingsProviderProtocol {

	func getGrouping(for behaviour: Behaviour) -> TodosGrouping {
		let key = key(for: behaviour)
		guard let value = UserDefaults.standard.string(forKey: key) else {
			return .none
		}
		return TodosGrouping(rawValue: value) ?? .none
	}
	
	func setGrouping(_ grouping: TodosGrouping, for behaviour: Behaviour) {
		let key = key(for: behaviour)
		UserDefaults.standard.setValue(grouping.rawValue, forKey: key)
	}
}

extension TodosSettingsProvider {

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

// MARK: - Helpers
private extension TodosSettingsProvider {

	func addObserver() {
		NotificationCenter.default.addObserver(
			forName: UserDefaults.didChangeNotification,
			object: nil,
			queue: .main
		) { [weak self] _ in
			self?.delegate?.settingsDidChange()
		}
	}
}
