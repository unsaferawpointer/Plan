//
//  TodosToolbarAssembly.swift
//  Plan
//
//  Created by Anton Cherkasov on 31.03.2024.
//

import AppKit

final class TodosToolbarAssembly {

	static func build(
		target: AnyObject,
		localization: TodosToolbarLocalizationProtocol = TodosToolbarLocalization()
	) -> [NSToolbarItem] {
		return
		[
			{
				let item = NSToolbarItem(itemIdentifier: .createTodo)
				item.isNavigational = false
				item.label = localization.newTodo
				item.visibilityPriority = .high
				item.view = {
					let button = NSButton()
					button.bezelStyle = .texturedRounded
					button.image = NSImage(systemSymbolName: "plus", accessibilityDescription: nil)
					button.target = target
					button.action = #selector(TodosViewController.newTodo(_:))
					return button
				}()
				return item
			}(),
			{
				let item = NSToolbarItem(itemIdentifier: .groupingItem)
				item.isNavigational = false
				item.label = localization.groupTodos
				item.visibilityPriority = .high
				item.view = {
					let button = NSComboButton()
					button.style = .unified
					button.image = NSImage(systemSymbolName: "square.grid.3x1.below.line.grid.1x2", accessibilityDescription: nil)

					let items = MenuBuilder.makeItems(
						[
							.custom(
								.grouping(.none),
								content: .init(
									title: localization.title(for: .none),
									keyEquivalent: "")
							),
							.separator,
							.custom(
								.grouping(.priority),
								content: .init(
									title: localization.title(for: .priority),
									keyEquivalent: "")
							),
							.custom(
								.grouping(.list), 
								content: .init(
									title: localization.title(for: .list),
									keyEquivalent: "")
							),
							.custom(
								.grouping(.status),
								content: .init(
									title: localization.title(for: .status),
									keyEquivalent: ""
								)
							)
						],
						target: target,
						action: #selector(MenuSupportable.menuItemHasBeenClicked(_:))
					)

					let menu = NSMenu()
					menu.items = items

					button.menu = menu

					return button
				}()
				return item
			}()
		]
	}
}
