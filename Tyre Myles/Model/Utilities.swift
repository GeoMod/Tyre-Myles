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

struct ErrorDetails: Identifiable {
	var id = UUID()

	let title: String
	let message: String
}

enum ErrorMessage {
	static let negativeNumber = "Unless the tires are still on your vehicle, removal mileage must not be less than installation mileage."
}

