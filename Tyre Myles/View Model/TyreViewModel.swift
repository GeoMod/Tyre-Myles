//
//  TireLogicModel.swift
//  Tyre Myles
//
//  Created by Daniel O'Leary on 11/23/21.
//

import SwiftUI

enum TireType: String, CaseIterable, Identifiable {
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


class TyreViewModel: ObservableObject {
	let errorMessage = "Unless the tires are still on your vehicle, removal mileage must not be less than installation mileage."

	@Published var isShowingAlert = false

	func checkLogicalMileageValues(install: Double?, removal: Double?, status: TireStatus) {
		guard let convertedInstall = install else { return }
		// No value was given for removal. Acceptable since tires may be on vehicle.
		guard let convertedRemoval = removal else { return }

		let result = convertedRemoval - convertedInstall

		// removal mileage cannot be greater than 0 but less than installation mileage.
		if status == .inStorage && result <= 0 {
			// a negative mileage value has resulted.
			// trigger alert
			isShowingAlert = true
		} else {
			// TODO: Save to CoreData from here?
			return
		}
	}

	// Takes the enum used to create the tire when it was initially saved, and works it backwards.
	func checkSeason(type: String) -> TireType {
		switch type {
			case "Summer":
				return .summer
			case "All Season":
				return .allSeason
			case "Winter":
				return .winter
			default:
				return .allSeason
		}
	}

	func loadTireLocation(status: Bool) -> TireStatus {
		// To set value of Picker when loading this Edit View.
		switch status {
			case true:
				return .inStorage
			case false:
				return .onVehicle
		}
	}

	func saveTireLocation(status: TireStatus) -> Bool {
		// To save the proper boolean value to CoreData
		switch status {
			case .onVehicle:
				return false
			case .inStorage:
				return true
		}
	}







}
