//
//  Primary.SectionModel.swift
//  Plan
//
//  Created by Anton Cherkasov on 22.06.2023.
//

extension Primary {

	/// View-Model of table section
	final class SectionModel {

		var id: SectionIdentifier

		var content: HeaderConfiguration

		var items: [ItemModel]

		// MARK: - Initialization

		/// Basic initialization
		///
		/// - Parameters:
		///    - id: View-model identifier
		///    - content: Field configuration
		///    - items: Children items
		init(id: SectionIdentifier, content: HeaderConfiguration, items: [ItemModel] = []) {
			self.id = id
			self.content = content
			self.items = items
		}
	}

	enum SectionIdentifier: Hashable {
		case basic
		case projects
	}
}
