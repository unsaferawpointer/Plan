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
	case shapes
	case weather
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
		case .shapes:
			return String(localized: "shapes_category", table: "Icons")
		case .weather:
			return String(localized: "weather_category", table: "Icons")
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
		case .shapes:
			[
				.circle,
				.square,
				.triangle,
				.diamond,
				.hexagon,
				.pentagon,
				.rhombus,
				.shield,
				.seal
			]
		case .weather:
			[
				.sunMax,
				.moon,
				.moonStars,
				.cloud,
				.cloudHeavyRain,
				.cloudSnow,
				.cloudBolt,
				.smoke,
				.tornado,
				.rainbow,
				.flame,
				.bolt,
				.mountain2,
				.cloudSun
			]
		}
	}
}

// MARK: - CaseIterable
extension IconCategory: CaseIterable {

	static var allCases: [IconCategory] {
		return [.objects, .sport, .devices, .health, .lifestyle, .building, .shapes, .weather]
	}
}
