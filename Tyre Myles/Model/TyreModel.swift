//
//  TyreModel.swift
//  Tyre Myles
//
//  Created by Daniel O'Leary on 4/17/22.
//

import Foundation


struct TyreModel {
	let installMiles: Double
	let removalMiles: Double
	let name: String
	let type: SeasonType
	let status: TireStatus
	let installDate: Date
	let removalDate: Date

	enum TireStatus {
		case onVehicle
		case inStorage
	}

	enum SeasonType: String, CaseIterable, Identifiable {
		// Identifiable for use in ForEach
		// Move to TyreModel Class
		var id: String { UUID().uuidString }

		case summer 	= "Summer"
		case allSeason 	= "All Season"
		case winter 	= "Winter"
	}
}
