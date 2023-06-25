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
}

// MARK: - PrimaryLocalization
extension PrimaryLocalizationMock: PrimaryLocalization {

	var allItem: String {
		allItemStub
	}

	var favoriteItem: String {
		favoriteItemStub
	}
}
