//
//  IconCategory.swift
//  Hierarchy
//
//  Created by Anton Cherkasov on 22.10.2023.
//

import Foundation

enum IconCategory: String{
	case objects
	case sport
	case devices
	case health
	case lifestyle
	case building
}

// MARK: - Computed properties
extension IconCategory {

	var displayName: String {
		switch self {
		case .objects:
			return String(localized: "objects_category", table: "Icons")
		case .sport:
			return String(localized: "sport_category", table: "Icons")
		case .devices:
			return String(localized: "devices_category", table: "Icons")
		case .health:
			return String(localized: "health_category", table: "Icons")
		case .lifestyle:
			return String(localized: "life_category", table: "Icons")
		case .building:
			return String(localized: "building_category", table: "Icons")
		}
	}

	var icons: [IconName] {
		switch self {
		case .objects:
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
		case .sport:
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
		case .devices:
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
		case .health:
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
		case .lifestyle:
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
		case .building:
			[
				.house,
				.building,
				.building2,
				.buildingColumns,
			]
		}
	}
}

// MARK: - CaseIterable
extension IconCategory: CaseIterable {

	static var allCases: [IconCategory] {
		return [.objects, .sport, .devices, .health, .lifestyle, .building]
	}
}
