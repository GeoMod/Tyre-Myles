//
//  TireLogicModel.swift
//  Tyre Myles
//
//  Created by Daniel O'Leary on 11/23/21.
//

import SwiftUI


final class TyreViewModel: ObservableObject {
	var model = CoreDataModel(managedObjectContext: PersistenceController.shared.container.viewContext)
	
	let errorMessage = "Unless the tires are still on your vehicle, removal mileage must not be less than installation mileage."

	@Published var tires = [TireEntity]()
	@Published var isShowingAlert = false

	var noTires: Bool {
		return model.tires.isEmpty
	}

	func checkLogicalMileageValues(with tire: TyreModel) {
		let result = tire.removalMiles - tire.installMiles

		if tire.status == .inStorage && result <= 0 {
			// a negative or 0 mileage value has resulted.
			// trigger alert
			isShowingAlert = true
		} else {
			model.saveTireProfileWith(tire: tire)
		}
	}

	func updateCurrentTire(with currentTire: TireEntity) {
		let result = currentTire.removalMiles - currentTire.installMiles

		if currentTire.isInStorage == true && result <= 0 {
			isShowingAlert = true
		} else {
			// save
			model.saveToMOC()
		}
	}

	// Takes the enum used to create the tire when it was initially saved, and works it backwards.
//	func checkSeason(type: String) -> SeasonType {
//		switch type {
//			case "Summer":
//				return .summer
//			case "All Season":
//				return .allSeason
//			case "Winter":
//				return .winter
//			default:
//				return .allSeason
//		}
//	}

//	func loadTireLocation(status: Bool) -> TireStatus {
//		// To set value of Picker when loading Edit View.
//		switch status {
//			case true:
//				return .inStorage
//			case false:
//				return .onVehicle
//		}
//	}


	func delete(at index: IndexSet) {
		model.deleteTire(at: index)
	}

	func fetchTires() {
		tires = model.tires
	}







}
