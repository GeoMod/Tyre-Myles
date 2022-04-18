//
//  TireLogicModel.swift
//  Tyre Myles
//
//  Created by Daniel O'Leary on 11/23/21.
//

import SwiftUI

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


class TyreViewModel: ObservableObject {
	let model = CoreDataModel(managedObjectContext: PersistenceController.shared.container.viewContext)
	
	let errorMessage = "Unless the tires are still on your vehicle, removal mileage must not be less than installation mileage."

	@Published var tires = [TireEntity]()
	@Published var isShowingAlert = false

	var noTires: Bool {
		return model.tires.isEmpty
	}

	func checkLogicalMileageValues(with tire: TyreModel) {
		let result = tire.removalMiles - tire.installMiles

		if tire.status == .inStorage && result <= 0 {
			// a negative mileage value has resulted.
			// trigger alert
			isShowingAlert = true
		} else {
			model.saveTireProfileWith(tire: tire)
		}
	}

	// Takes the enum used to create the tire when it was initially saved, and works it backwards.
	func checkSeason(type: String) -> SeasonType {
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

	func delete(at index: IndexSet) {
		model.deleteTire(at: index)
	}

	func fetchTires() {
		tires = model.tires
	}







}
