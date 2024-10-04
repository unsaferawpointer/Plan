//
//  PlanViewController+MenuSupportable.swift
//  Plan
//
//  Created by Anton Cherkasov on 26.08.2024.
//

import Cocoa

// MARK: - MenuSupportable
extension PlanViewController: MenuSupportable {

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
	func undo(_ sender: NSMenuItem) {
		output?.undo()
	}

	@IBAction
	func redo(_ sender: NSMenuItem) {
		output?.redo()
	}

	@IBAction
	func fold(_ sender: NSMenuItem) {
		output?.fold()
	}

	@IBAction
	func unfold(_ sender: NSMenuItem) {
		output?.unfold()
	}

	@IBAction
	func cut(_ sender: NSMenuItem) {
		output?.cut()
	}

	@IBAction
	func paste(_ sender: NSMenuItem) {
		output?.paste()
	}

	@IBAction
	func copy(_ sender: NSMenuItem) {
		output?.copy()
	}
}
