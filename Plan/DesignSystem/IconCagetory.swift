//
//  IconCagetory.swift
//  Hierarchy
//
//  Created by Anton Cherkasov on 22.10.2023.
//

import Foundation

struct IconCategory {

	var title: String

	var icons: [String]

	// MARK: - Initialization

	init(title: String, icons: [String]) {
		self.title = title
		self.icons = icons
	}
}

// MARK: - Icons sets
extension IconCategory {

	static let objectsAndTools: IconCategory = .init(
		title: "Objects & Tools",
		icons:
			[
				"folder",
				"archivebox",
				"doc",
				"doc.text",
				"note.text",
				"book.closed",
				"creditcard",
				"hammer",
				"flask",
				"cube",
				"slider.horizontal.2.square"
			]
	)

	static let sport: IconCategory = .init(
		title: "Sport",
		icons:
			[
				"baseball",
				"basketball",
				"football",
				"tennisball",
				"volleyball",
				"skateboard",
				"skis",
				"snowboard",
				"surfboard"
			]
	)

	static let devices: IconCategory = .init(
		title: "Devices",
		icons:
			[
				"keyboard",
				"printer",
				"scanner",
				"display",
				"laptopcomputer",
				"headphones",
				"av.remote",
				"tv",
				"gamecontroller",
				"camera",
				"candybarphone",
				"smartphone",
				"simcard",
				"sdcard"
			]
	)

	static let health: IconCategory = .init(
		title: "Health",
		icons:
			[
				"cross.case",
				"pills",
				"cross",
				"flask",
				"cross.vial",
				"heart.text.square",
				"syringe",
				"medical.thermometer",
				"microbe",
				"bandage"
			]
	)

	static let life: IconCategory = .init(
		title: "Everyday life",
		icons:
			[
				"tshirt",
				"shoe",
				"comb",
				"cup.and.saucer",
				"wineglass",
				"fork.knife",
				"bag",
				"gym.bag",
				"suitcase"
			]
	)
}

extension IconCategory {

	static var categories: [IconCategory] =
	[
		.objectsAndTools,
		.sport,
		.devices,
		.health,
		.life
	]
}
