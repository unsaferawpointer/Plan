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

		// MARK: - Initialization

		/// Basic initialization
		///
		/// - Parameters:
		///    - id: View-model identifier
		///    - tintColor: Tint color of the icon
		///    - content: Label configuration of the content
		init(id: AnyHashable, tintColor: NSColor? = nil, content: LabelConfiguration) {
			self.id = id
			self.tintColor = tintColor
			self.content = content
		}

	}
}
