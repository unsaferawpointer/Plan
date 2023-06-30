//
//  PrimaryLocalizationMock.swift
//  PlanTests
//
//  Created by Anton Cherkasov on 24.06.2023.
//

@testable import Plan

final class PrimaryLocalizationMock {

	var allItemStub: String = .random

	var favoriteItemStub: String = .random

	var defaultProjectNameStub: String = .random

	var addProjectButtonTitleStub: String = .random

	var deleteContextMenuItemTitleStub: String = .random
}

// MARK: - PrimaryLocalization
extension PrimaryLocalizationMock: PrimaryLocalization {

	var deleteContextMenuItemTitle: String {
		deleteContextMenuItemTitleStub
	}

	var defaultProjectName: String {
		defaultProjectNameStub
	}

	var addProjectButtonTitle: String {
		addProjectButtonTitleStub
	}

	var allItem: String {
		allItemStub
	}

	var favoriteItem: String {
		favoriteItemStub
	}
}
