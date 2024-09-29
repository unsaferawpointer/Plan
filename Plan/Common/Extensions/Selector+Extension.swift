//
//  Selector+Extension.swift
//  Plan
//
//  Created by Anton Cherkasov on 29.09.2024.
//

import AppKit

extension Selector {

	static var undo = Selector(("undo:"))

	static var redo = Selector(("redo:"))

	static var cut = Selector(("cut:"))

	static var copy = Selector(("copy:"))

	static var paste = Selector(("paste:"))

	static var selectAll = Selector(("selectAll:"))

	static var createNew = Selector(("createNew:"))

	static var fold = Selector(("fold:"))

	static var unfold = Selector(("unfold:"))

	static var delete = Selector(("delete:"))

	static var toggleToolbarShown = Selector(("toggleToolbarShown:"))

	static var runToolbarCustomizationPalette = Selector(("runToolbarCustomizationPalette:"))

	static var toggleFullScreen = Selector(("toggleFullScreen:"))

	static var performMiniaturize = Selector(("performMiniaturize:"))

	static var arrangeInFront = Selector(("arrangeInFront:"))

	static var toggleBookmarked = Selector(("toggleBookmark:"))

	static var toggleCompleted = Selector(("toggleCompleted:"))

}
