//
//  SidebarLocalization.swift
//  Plan
//
//  Created by Anton Cherkasov on 02.11.2024.
//

import Foundation

protocol SidebarLocalizationProtocol {
	var documentLabel: String { get }
	var bookmarksSectionLabel: String { get }
}

final class SidebarLocalization { }

// MARK: - SidebarLocalizationProtocol
extension SidebarLocalization: SidebarLocalizationProtocol {

	var documentLabel: String {
		return String(localized: "document_label", table: "SidebarLocalizable")
	}

	var bookmarksSectionLabel: String {
		return String(localized: "bookmarks_section_label", table: "SidebarLocalizable")
	}
}
