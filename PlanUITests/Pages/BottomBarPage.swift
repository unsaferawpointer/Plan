//
//  BottomBarPage.swift
//  PlanUITests
//
//  Created by Anton Cherkasov on 19.10.2024.
//

import XCTest

final class BottomBarPage {

	var element: XCUIElement

	init(element: XCUIElement) {
		self.element = element
	}
}

extension BottomBarPage {

	func checkLeadingLabel(expectedTitle title: String) {
		let value = element.staticTexts["leading-label"].value
		XCTAssertEqual(title, value as? String)
	}

	func checkTrailingLabel(expectedTitle title: String) {
		let value = element.staticTexts["trailing-label"].value
		XCTAssertEqual(title, value as? String)
	}

	func checkProgress(expectedValue progress: Double) {
		let value = element.progressIndicators["progress"].value
		XCTAssertEqual(progress, value as? Double)
	}
}
