//
//  TireModel.swift
//  Tyre Myles
//
//  Created by Daniel O'Leary on 10/21/21.
//

import Foundation


/*
 Name
 Size
 Purpose (Summer/Winter)
 Size
 Install Date
 Removal Date
 Install Miles
 Removal Miles
 Total Miles

 */

struct TireModel {

	enum Season {
		case summer
		case winter
	}

	let id: UUID
	let name: String
	let season: Season
	let size: Int
	let installDate: Date
	let removalDate: Date
	let installDistance: Int
	let removalDistance: Int
	let totalDistance: Int

}


let newTire = TireModel(id: UUID(), name: "Winter", season: .winter, size: 22, installDate: .now, removalDate: Date(timeIntervalSinceNow: 300), installDistance: 15, removalDistance: 300, totalDistance: 285)

let season = newTire.season
