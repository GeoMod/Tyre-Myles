//
//  Utilities.swift
//  Tyre Myles
//
//  Created by Daniel O'Leary on 4/19/22.
//

import Foundation

struct ErrorDetails: Identifiable {
	var id = UUID()

	let title: String
	let message: String
}

enum ErrorMessage {
	static let negativeNumber = "Unless the tires are still on your vehicle, removal mileage must not be less than installation mileage."

	static let coreDataError = "There was an error saving to the disc."
	static let mocFetchError = "Failed to load objects from the disc."

}

