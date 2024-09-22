//
//  PasteboardFacadeMock.swift
//  PlanTests
//
//  Created by Anton Cherkasov on 24.09.2024.
//

@testable import Plan

final class PasteboardFacadeMock {
	private(set) var invocations: [Action] = []
	var stubs: Stubs = .init()
}

// MARK: - PasteboardFacadeProtocol
extension PasteboardFacadeMock: PasteboardFacadeProtocol {

	func contains(_ types: Set<PasteboardInfo.`Type`>) -> Bool {
		invocations.append(.contains(types: types))
		return stubs.contains
	}
	
	func info(for types: Set<PasteboardInfo.`Type`>) -> PasteboardInfo? {
		invocations.append(.info(types: types))
		return stubs.info
	}
	
	func setInfo(_ info: PasteboardInfo, clearContents: Bool) {
		invocations.append(.setInfo(info: info, clearContents: clearContents))
	}
}

// MARK: - Nested data structs
extension PasteboardFacadeMock {

	enum Action {
		case contains(types: Set<PasteboardInfo.`Type`>)
		case info(types: Set<PasteboardInfo.`Type`>)
		case setInfo(info: PasteboardInfo, clearContents: Bool)
	}

	struct Stubs {
		let contains: Bool = true
		let info: PasteboardInfo? = .init()
	}
}
