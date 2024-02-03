//
//  SidebarItem.swift
//  Plan
//
//  Created by Anton Cherkasov on 27.01.2024.
//

import Foundation
import AppKit

enum SidebarItem: CaseIterable {
	case focus
	case backlog
	case favorites
	case projects
	case archieve
}

extension SidebarItem {

	var title: String {
		switch self {
		case .focus:
			return "Focus"
		case .backlog:
			return "Backlog"
		case .favorites:
			return "Favorites"
		case .projects:
			return "Projects"
		case .archieve:
			return "Archieve"
		}
	}

	var icon: String {
		switch self {
		case .focus:
			return "sun.max.fill"
		case .backlog:
			return "square.stack.3d.up.fill"
		case .favorites:
			return "star.fill"
		case .projects:
			return "doc.text.fill"
		case .archieve:
			return "shippingbox.fill"
		}
	}

	var color: NSColor? {
		switch self {
		case .focus:
			return .systemYellow
		case .backlog:
			return nil
		case .favorites:
			return nil
		case .projects:
			return nil
		case .archieve:
			return nil
		}
	}
}

// MARK: - Hashable
extension SidebarItem: Hashable { }
