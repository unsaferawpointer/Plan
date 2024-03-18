//
//  TodoItemFactory.swift
//  Plan
//
//  Created by Anton Cherkasov on 18.03.2024.
//

import Foundation

protocol TodoItemsFactoryProtocol {
	func makeItems(from todos: [Todo], grouping: TodosGrouping, behaviour: Behaviour) -> [TableItem]
}

final class TodoItemFactory { }

// MARK: - TodoItemFactoryProtocol
extension TodoItemFactory: TodoItemsFactoryProtocol {

	func makeItems(from todos: [Todo], grouping: TodosGrouping, behaviour: Behaviour) -> [TableItem] {
		var total: [TableItem] = []

		let elements = self.elements(for: behaviour)

		switch grouping {
		case .none:
			let items = todos.map { todo in
				makeConfiguration(from: todo, elements: elements)
			}
			total.append(contentsOf: items)
		case .list:
			let grouped = Dictionary(grouping: todos) { todo in
				return todo.listName ?? ""
			}

			let sorted = grouped.sorted { $0.key < $1.key }

			for section in sorted {
				total.append(.header(section.key))
				var modificatedElements = elements
				modificatedElements.remove(.trailingLabel)
				let items = section.value.map { todo in
					makeConfiguration(from: todo, elements: modificatedElements)
				}
				total.append(contentsOf: items)
			}
		case .priority:
			let grouped = Dictionary(grouping: todos) { $0.priority }
			let sorted = grouped.sorted { $0.key.rawValue > $1.key.rawValue }

			for section in sorted {
				switch section.key {
				case .low:
					total.append(.header("Low Priority"))
				case .medium:
					total.append(.header("Medium Priority"))
				case .high:
					total.append(.header("High Priority"))
				}
				let items = section.value.map { todo in
					makeConfiguration(from: todo, elements: elements)
				}
				total.append(contentsOf: items)
			}
		case .status:
			let grouped = Dictionary(grouping: todos) { $0.status }
			let sorted = grouped.sorted { $0.key.rawValue < $1.key.rawValue }

			for section in sorted {
				switch section.key {
				case .default:
					total.append(.header("Incomplete"))
				case .inFocus:
					total.append(.header("In Focus"))
				case .done:
					total.append(.header("Done"))
				}
				let items = section.value.map { todo in
					makeConfiguration(from: todo, elements: elements)
				}
				total.append(contentsOf: items)
			}
		}

		return total
	}
}

// MARK: - Helpers
private extension TodoItemFactory {

	func makeConfiguration(from todo: Todo, elements: CellElements) -> TableItem {

		let iconTint = todo.isDone ? .secondaryText : todo.priority.color
		let textColor: TintColor = todo.isDone ? .secondaryText : .primaryText

		var modificatedElements = elements
		if todo.priority == .low || todo.isDone {
			modificatedElements.remove(.icon)
		}

		let configuration = TodoCellConfiguration(
			checkboxValue: todo.status == .done,
			iconTint: iconTint,
			iconName: "bolt.fill",
			text: todo.text,
			textColor: textColor,
			trailingText: todo.listName ?? "",
			elements: modificatedElements
		)

		return .custom(id: todo.id, configuration: configuration)
	}

	func elements(for behaviour: Behaviour) -> CellElements {
		switch behaviour {
		case .inFocus:	return [.icon, .textfield, .trailingLabel]
		case .backlog:	return [.icon, .textfield, .trailingLabel]
		case .archieve:	return [.icon, .textfield, .trailingLabel]
		case .list:		return [.icon, .textfield]
		}
	}
}
