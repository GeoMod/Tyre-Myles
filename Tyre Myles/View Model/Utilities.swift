//
//  Utilities.swift
//  Tyre Myles
//
//  Created by Daniel O'Leary on 4/19/22.
//

import Foundation

enum SeasonType: String, CaseIterable, Identifiable {
	// Identifiable for use in ForEach
	var id: String { UUID().uuidString }

	case summer 	= "Summer"
	case allSeason 	= "All Season"
	case winter 	= "Winter"
}

enum TireStatus {
	case onVehicle
	case inStorage
}
