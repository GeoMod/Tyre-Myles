//
//  TireLogicModel.swift
//  Tyre Myles
//
//  Created by Daniel O'Leary on 11/23/21.
//

import Foundation

enum TireType: String, CaseIterable, Identifiable {
	// Identifiable for use in ForEach
	var id: String { UUID().uuidString }

	case summer = "Summer"
	case allSeason = "All Season"
	case winter = "Winter"
}

enum TireStatus {
	case onVehicle
	case inStorage
}


struct TyreViewModel {
	let errorMessage = "Unless the tires are still on your vehicle, removal mileage must not be less than installation mileage."
	let submitMessage = "OK"

	func checkLogicalMileageValues(install: Double?, removal: Double?, status: TireStatus) -> Bool {
		guard let convertedInstall = install else { return false }
		guard let convertedRemoval = removal else {
			// No value was given for removal. Acceptable since tires may be on vehicle.
			return false
		}

		let result = convertedRemoval - convertedInstall
//		let result = removal - install

		// removal mileage cannot be greater than 0 but less than installation mileage.
		if status == .inStorage && result <= 0 {
			// a negative mileage value has resulted.
			// trigger alert
			return true
		} else {
			return false
		}
	}
}
