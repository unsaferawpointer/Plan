//
//  IconName.swift
//  Plan
//
//  Created by Anton Cherkasov on 25.08.2024.
//

import Foundation

enum IconName: Int {

	// MARK: - Common

	case flag = 0

	// MARK: - Objects
	case folder = 10
	case archivebox = 11
	case doc = 12
	case docText = 13
	case noteText = 14
	case bookClosed = 15
	case creditcard = 16
	case hammer = 17
	case flask = 18
	case cube = 19
	case sliderHorizontal2Square = 20

	// MARK: - Sport
	case baseball = 100
	case basketball = 101
	case football = 102
	case tennisball = 103
	case volleyball = 104
	case skateboard = 105
	case skis = 106
	case snowboard = 107
	case surfboard = 108

	// MARK: - Devices
	case keyboard = 200
	case printer = 201
	case scanner = 202
	case display = 203
	case laptopcomputer = 204
	case headphones = 205
	case avRemote = 206
	case tv = 207
	case gamecontroller = 208
	case camera = 209
	case candybarphone = 210
	case smartphone = 211
	case simcard = 212
	case sdcard = 213

	// MARK: - Health
	case crossCase = 300
	case pills = 301
	case cross = 302
	case crossVial = 303
	case heartTextSquare = 304
	case syringe = 305
	case medicalThermometer = 306
	case microbe = 307
	case bandage = 308

	// MARK: - Everyday life
	case tshirt = 400
	case shoe = 401
	case comb = 402
	case cupAndSaucer = 403
	case wineglass = 404
	case forkKnife = 405
	case bag = 406
	case gymBag = 407
	case suitcase = 408

	// MARK: - Building
	case house = 500
	case building2 = 501
	case building = 502
	case buildingColumns = 503

	// MARK: - Shapes [600 - 649]
	case circle = 600
	case square	= 601
	case triangle = 602
	case diamond = 603
	case hexagon = 604
	case pentagon = 605
	case rhombus = 606
	case shield = 607
	case seal = 608

	// MARK: - Wheather [650 - 700]
	case sunMax = 650
	case moon = 651
	case moonStars = 652
	case cloudSun = 653
	case cloud = 654
	case cloudHeavyRain = 655
	case cloudSnow = 656
	case cloudBolt = 657
	case smoke = 658
	case tornado = 659
	case rainbow = 660
	case flame = 661
	case bolt = 662
	case mountain2 = 663

}

// MARK: - Codable
extension IconName: Codable { }

// MARK: - Computed properties
extension IconName {

	var systemName: String {
		switch self {
		case .flag: "flag.fill"
			// MARK: - Objects
		case .folder: "folder.fill"
		case .archivebox: "archivebox.fill"
		case .doc: "doc.fill"
		case .docText: "doc.text.fill"
		case .noteText: "note.text"
		case .bookClosed: "book.closed.fill"
		case .creditcard: "creditcard.fill"
		case .hammer: "hammer.fill"
		case .flask: "flask.fill"
		case .cube: "cube.fill"
		case .sliderHorizontal2Square: "slider.horizontal.2.square"

			// MARK: - Sport
		case .baseball: "baseball.fill"
		case .basketball: "basketball.fill"
		case .football: "football.fill"
		case .tennisball: "tennisball.fill"
		case .volleyball: "volleyball.fill"
		case .skateboard: "skateboard.fill"
		case .skis: "skis.fill"
		case .snowboard: "snowboard.fill"
		case .surfboard: "surfboard.fill"

			// MARK: - Devices
		case .keyboard: "keyboard.fill"
		case .printer: "printer.fill"
		case .scanner: "scanner.fill"
		case .display: "display"
		case .laptopcomputer: "laptopcomputer"
		case .headphones: "headphones"
		case .avRemote: "av.remote.fill"
		case .tv: "tv.fill"
		case .gamecontroller: "gamecontroller.fill"
		case .camera: "camera.fill"
		case .candybarphone: "candybarphone"
		case .smartphone: "smartphone"
		case .simcard: "simcard.fill"
		case .sdcard: "sdcard.fill"

			// MARK: - Health
		case .crossCase: "cross.case.fill"
		case .pills: "pills.fill"
		case .cross: "cross.fill"
		case .crossVial: "cross.vial.fill"
		case .heartTextSquare: "heart.text.square.fill"
		case .syringe: "syringe.fill"
		case .medicalThermometer: "medical.thermometer.fill"
		case .microbe: "microbe.fill"
		case .bandage: "bandage.fill"

			// MARK: - Everyday life
		case .tshirt: "tshirt.fill"
		case .shoe: "shoe.fill"
		case .comb: "comb.fill"
		case .cupAndSaucer: "cup.and.saucer.fill"
		case .wineglass: "wineglass.fill"
		case .forkKnife: "fork.knife"
		case .bag: "bag.fill"
		case .gymBag: "gym.bag.fill"
		case .suitcase: "suitcase.fill"

		// MARK: - Building
		case .house: "house.fill"
		case .building2: "building.2.fill"
		case .building: "building.fill"
		case .buildingColumns: "building.columns.fill"

		// MARK: - Shapes
		case .circle: "circle.fill"
		case .square: "square.fill"
		case .triangle: "triangle.fill"
		case .diamond: "diamond.fill"
		case .hexagon: "hexagon.fill"
		case .pentagon: "pentagon.fill"
		case .rhombus: "rhombus.fill"
		case .shield: "shield.fill"
		case .seal: "seal.fill"

		// MARK: - Weather
		case .sunMax: "sun.max.fill"
		case .moon: "moon.fill"
		case .moonStars: "moon.stars.fill"
		case .cloud: "cloud.fill"
		case .cloudHeavyRain: "cloud.heavyrain.fill"
		case .cloudSnow: "cloud.snow.fill"
		case .cloudBolt: "cloud.bolt.fill"
		case .smoke: "smoke.fill"
		case .tornado: "tornado"
		case .rainbow: "rainbow"
		case .flame: "flame.fill"
		case .bolt: "bolt.fill"
		case .mountain2: "mountain.2.fill"
		case .cloudSun: "cloud.sun.fill"
		}
	}
}
