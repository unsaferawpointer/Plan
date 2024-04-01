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

	var settingsProvider: SidebarSettingsProviderProtocol

	var itemsFactory: SidebarItemsFactoryProtocol

	var interactor: SidebarInteractorProtocol?

	weak var titleDelegate: TitleDelegate?

	weak var view: SidebarView?

	// MARK: - Initialization

	init(
		settingsProvider: SidebarSettingsProviderProtocol,
		itemsFactory: SidebarItemsFactoryProtocol,
		titleDelegate: TitleDelegate
	) {
		self.settingsProvider = settingsProvider
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
		invalidateSelection(lists: lists)
	}
}

// MARK: - SidebarViewOutput
extension SidebarPresenter: SidebarViewOutput {

	func viewDidChange(state newState: ViewState) {
		guard case .willAppear = newState else {
			return
		}

		let staticContent = itemsFactory.makeStaticContent()
		view?.display(staticContent: staticContent)

		let selection = settingsProvider.selection
		if let item = staticContent.first(where: { $0.id == selection }) {
			view?.selectItem(selection)
			titleDelegate?.titleDidChange(item.title)
		}

		do {
			try interactor?.fetchLists()
		} catch {
			// TODO: - Handle action
		}
	}

	func labelDidChangeText(_ newText: String, forItem withId: UUID) {
		do {
			try interactor?.perform(.setTitle(newText), forLists: [withId])
		} catch {
			// TODO: - Handle action
		}
	}

	func selectionDidChange(_ newValue: SidebarItem) {
		settingsProvider.selection = newValue.id
		titleDelegate?.titleDidChange(newValue.title)
	}
}

// MARK: - MenuDelegate
extension SidebarPresenter: MenuDelegate {

	func menuItemHasBeenClicked(_ item: MenuItem.Identifier) {
		switch item {
		case .newList:
			do {
				let id = UUID()
				settingsProvider.selection = .list(id)

				let title = itemsFactory.makeNewListTitle()

				try interactor?.perform(.insert(id, title: title))

				titleDelegate?.titleDidChange(title)

				view?.selectItem(.list(id))
				view?.scrollTo(.list(id))
				view?.focusOn(.list(id))

			} catch {
				// TODO: - Handle action
			}
		case .delete:
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
		case .delete:
			guard case .list = view?.clickedItem() else {
				return false
			}
			return true
		default:
			return false
		}
	}
}

// MARK: - Helpers
private extension SidebarPresenter {

	func invalidateSelection(lists: [List]) {
		guard case let .list(id) = settingsProvider.selection else {
			return
		}
		if let list = lists.first(where: { $0.uuid == id }) {
			view?.selectItem(.list(id))
			titleDelegate?.titleDidChange(list.title)
		} else if let item = itemsFactory.makeStaticContent().first {
			view?.selectItem(item.id)
			settingsProvider.selection = item.id
			titleDelegate?.titleDidChange(item.title)
		} else {
			fatalError()
		}
	}
}
