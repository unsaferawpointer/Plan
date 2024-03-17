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

	var itemsFactory: SidebarItemsFactoryProtocol

	var interactor: SidebarInteractorProtocol?

	weak var titleDelegate: TitleDelegate?

	weak var view: SidebarView?

	// MARK: - Initialization

	init(
		stateProvider: SidebarStateProviderProtocol,
		itemsFactory: SidebarItemsFactoryProtocol,
		titleDelegate: TitleDelegate
	) {
		self.stateProvider = stateProvider
		self.itemsFactory = itemsFactory
		self.titleDelegate = titleDelegate
	}
}

// MARK: - SidebarPresenterProtocol
extension SidebarPresenter: SidebarPresenterProtocol {

	func present(_ lists: [List]) {

		let dynamicContent = itemsFactory.makeDynamicContent(from: lists)
		let sectionTitle = itemsFactory.makeSectionTitle()

		view?.display(sectionTitle: sectionTitle, dynamicContent: dynamicContent)
	}
}

// MARK: - SidebarViewOutput
extension SidebarPresenter: SidebarViewOutput {

	func viewDidChange(state newState: ViewState) {
		guard case .didLoad = newState else {
			return
		}

		let staticContent = itemsFactory.makeStaticContent()
		view?.display(staticContent: staticContent)

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
		case .newList, .file, .editor:
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
