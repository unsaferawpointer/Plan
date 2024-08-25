//
//  IconCagetory.swift
//  Hierarchy
//
//  Created by Anton Cherkasov on 22.10.2023.
//

import Foundation

struct IconCategory {

	var title: String

	var icons: [IconName]

	// MARK: - Initialization

	init(title: String, icons: [IconName]) {
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
				.folder,
				.archivebox,
				.doc,
				.docText,
				.noteText,
				.bookClosed,
				.creditcard,
				.hammer,
				.flask,
				.cube,
				.sliderHorizontal2Square
			]
	)

	static let sport: IconCategory = .init(
		title: "Sport",
		icons:
			[
				.baseball,
				.basketball,
				.football,
				.tennisball,
				.volleyball,
				.skateboard,
				.skis,
				.snowboard,
				.surfboard
			]
	)

	static let devices: IconCategory = .init(
		title: "Devices",
		icons:
			[
				.keyboard,
				.printer,
				.scanner,
				.display,
				.laptopcomputer,
				.headphones,
				.avRemote,
				.tv,
				.gamecontroller,
				.camera,
				.candybarphone,
				.smartphone,
				.simcard,
				.sdcard
			]
	)

	static let health: IconCategory = .init(
		title: "Health",
		icons:
			[
				.crossCase,
				.pills,
				.cross,
				.crossVial,
				.heartTextSquare,
				.syringe,
				.medicalThermometer,
				.microbe,
				.bandage
			]
	)

	static let life: IconCategory = .init(
		title: "Everyday life",
		icons:
			[
				.tshirt,
				.shoe,
				.comb,
				.cupAndSaucer,
				.wineglass,
				.forkKnife,
				.bag,
				.gymBag,
				.suitcase
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
