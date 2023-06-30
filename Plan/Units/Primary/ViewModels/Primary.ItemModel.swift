//
//  Primary.NavigationModel.swift
//  Plan
//
//  Created by Anton Cherkasov on 22.06.2023.
//

import Cocoa

import Foundation

extension Primary {

	/// View-model of the navigation item
	final class ItemModel {

		var id: AnyHashable

		var tintColor: NSColor?

		var content: LabelConfiguration

		var menu: [MenuItem]

		// MARK: - Initialization

		/// Basic initialization
		///
		/// - Parameters:
		///    - id: View-model identifier
		///    - tintColor: Tint color of the icon
		///    - content: Label configuration of the content
		///    - menu: Context menu for item
		init(
			id: AnyHashable,
			tintColor: NSColor? = nil,
			content: LabelConfiguration,
			menu: [MenuItem] = []
		) {
			self.id = id
			self.tintColor = tintColor
			self.content = content
			self.menu = menu
		}

	}
}
