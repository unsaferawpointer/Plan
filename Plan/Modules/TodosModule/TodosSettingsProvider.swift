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

	var grouping: TodosGrouping { get set }

	var delegate: TodosSettingsDelegate? { get set }
}

final class TodosSettingsProvider {

	weak var delegate: TodosSettingsDelegate?

	var behaviour: Behaviour

	init(behaviour: Behaviour) {
		self.behaviour = behaviour
		addObserver()
	}
}

// MARK: - TodosSettingsProviderProtocol
extension TodosSettingsProvider: TodosSettingsProviderProtocol {

	var grouping: TodosGrouping {
		get {
			let key = {
				switch behaviour {
				case .inFocus:
					return "inFocus_grouping"
				case .backlog:
					return "backlog_grouping"
				case .archieve:
					return "archieve_grouping"
				case .list:
					return "list_grouping"
				}
			}()
			guard let value = UserDefaults.standard.string(forKey: key) else {
				return .none
			}
			return TodosGrouping(rawValue: value) ?? .none
		}
		set {
			let key = {
				switch behaviour {
				case .inFocus:
					return "inFocus_grouping"
				case .backlog:
					return "backlog_grouping"
				case .archieve:
					return "archieve_grouping"
				case .list:
					return "list_grouping"
				}
			}()
			UserDefaults.standard.setValue(newValue.rawValue, forKey: key)
		}
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
