//
//  SidebarItem.swift
//  Plan
//
//  Created by Anton Cherkasov on 27.01.2024.
//

import Foundation
import AppKit

enum SidebarItem {
	case focus
	case backlog
	case favorites
	case projects
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
		}
	}
}

// MARK: - Hashable
extension SidebarItem: Hashable { }
