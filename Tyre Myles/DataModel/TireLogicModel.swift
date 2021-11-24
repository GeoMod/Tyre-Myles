//
//  TireLogicModel.swift
//  Tyre Myles
//
//  Created by Daniel O'Leary on 11/23/21.
//

import SwiftUI

class TireMileageLogic {
	// MARK: More functionality should be added here to consolodate code from
	// AddTireView and EditTireView. Those items are marked in those files.
	let errorMessage = "Unless the tires are still on your vehicle, removal mileage must not be less than installation mileage."
	let submitMessage = "That Makes Sense"

	func checkLogicalMileageValues(install: String, removal: String, status: TireStatus) -> Bool {
		// removal mileage cannot be greater than 0 but less than installation mileage.
		guard let convertedInstall = Int(install) else { return false }
		guard let convertedRemoval = Int(removal) else {
			// No value was given for removal. Acceptable since tires may be on vehicle.
			return false
		}

		let result = convertedRemoval - convertedInstall

		if status == .inStorage && result <= 0 {
			// a negative mileage value has resulted.
			// trigger alert
			return true
		} else {
			return false
		}
	}
}
