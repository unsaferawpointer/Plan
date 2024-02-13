//
//  SidebarPresenter.swift
//  Plan
//
//  Created by Anton Cherkasov on 27.01.2024.
//

import Foundation

protocol SidebarPresenterProtocol: AnyObject {
	func present(_ lists: [List])
}

final class SidebarPresenter {

	var stateProvider: SidebarStateProviderProtocol

	var interactor: SidebarInteractorProtocol?

	weak var titleDelegate: TitleDelegate?

	weak var view: SidebarView?

	// MARK: - Initialization

	init(
		stateProvider: SidebarStateProviderProtocol,
		titleDelegate: TitleDelegate
	) {
		self.stateProvider = stateProvider
		self.titleDelegate = titleDelegate
	}
}

// MARK: - SidebarPresenterProtocol
extension SidebarPresenter: SidebarPresenterProtocol {

	func present(_ lists: [List]) {

		let staticContent: [SidebarItem] =
		[
			.init(id: .inbox, icon: "tray.fill", title: "Inbox", isEditable: false),
			.init(id: .backlog, icon: "square.stack.3d.up.fill", title: "Backlog", isEditable: false),
			.init(id: .archieve, icon: "shippingbox.fill", title: "Archieve", isEditable: false)
		]

		let dynamicContent = lists.map { list in
			SidebarItem(
				id: .list(list.uuid),
				icon: "doc.text",
				title: list.title,
				isEditable: true
			)
		}

		view?.display(
			staticContent: staticContent,
			sectionTitle: "Lists",
			dynamicContent: dynamicContent
		)
	}
}

// MARK: - SidebarViewOutput
extension SidebarPresenter: SidebarViewOutput {

	func viewDidChange(state newState: ViewState) {
		guard case .didLoad = newState else {
			return
		}

		do {
			try interactor?.fetchLists()
		} catch {
			// TODO: - Handle action
		}

		let route = stateProvider.getRoute()
		view?.selectItem(route)
	}

	func labelDidChangeText(_ newText: String, forItem withId: UUID) {
		do {
			try interactor?.perform(.setTitle(newText), forLists: [withId])
		} catch {
			// TODO: - Handle action
		}
	}

	func selectionDidChange(_ newValue: SidebarItem) {
		stateProvider.navigate(to: newValue.id)
		titleDelegate?.titleDidChange(newValue.title)
	}
}

// MARK: - MenuDelegate
extension SidebarPresenter: MenuDelegate {

	func menuItemHasBeenClicked(_ item: MenuItem.Identifier) {
		switch item {
		case .newList:
			do {
				try interactor?.perform(.insert("New list"))
			} catch {
				// TODO: - Handle action
			}
		case .deleteList:
			do {
				guard case let .list(id) = view?.clickedItem() else {
					return
				}
				try interactor?.perform(.delete([id]))
			} catch {
				// TODO: - Handle action
			}
		default:
			break
		}
	}
	
	func validateMenuItem(_ item: MenuItem.Identifier) -> Bool {
		switch item {
		case .newList:
			return true
		case .deleteList:
			guard case .list = view?.clickedItem() else {
				return false
			}
			return true
		default:
			return false
		}
	}
}
