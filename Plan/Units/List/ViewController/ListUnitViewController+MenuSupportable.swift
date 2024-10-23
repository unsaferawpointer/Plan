//
//  ListUnitViewController+MenuSupportable.swift
//  Plan
//
//  Created by Anton Cherkasov on 23.10.2024.
//

import Cocoa

// MARK: - MenuSupportable
extension ListUnitViewController: MenuSupportable {

	@IBAction
	func createNew(_ sender: NSMenuItem) {
		output?.createNew()
	}

	@IBAction
	func delete(_ sender: NSMenuItem) {
		output?.deleteItems()
	}

	@IBAction
	func toggleBookmark(_ sender: NSMenuItem) {
		let enabled = sender.state == .on
		output?.setBookmark(!enabled)
	}

	@IBAction
	func toggleCompleted(_ sender: NSMenuItem) {
		let enabled = sender.state == .on
		output?.setState(!enabled)
	}

	@IBAction
	func setPriority(_ sender: NSMenuItem) {
		let rawValue = sender.tag
		output?.setPriority(rawValue)
	}

	@IBAction
	func setEstimation(_ sender: NSMenuItem) {
		let number = sender.tag
		output?.setEstimation(number)
	}

	@IBAction
	func setIcon(_ sender: NSMenuItem) {
		let iconName = sender.representedObject as? IconName
		output?.setIcon(iconName)
	}

	@IBAction
	func setColor(_ sender: NSMenuItem) {
		let color = Color(rawValue: sender.tag)
		output?.setColor(color)
	}

	@IBAction
	func undo(_ sender: NSMenuItem) {
		output?.undo()
	}

	@IBAction
	func redo(_ sender: NSMenuItem) {
		output?.redo()
	}
}
