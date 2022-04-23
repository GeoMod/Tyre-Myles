//
//  TireLogicModel.swift
//  Tyre Myles
//
//  Created by Daniel O'Leary on 11/23/21.
//

import SwiftUI


final class TyreViewModel: ObservableObject {
	@ObservedObject var model = CoreDataModel(managedObjectContext: PersistenceController.shared.container.viewContext)
	@Published var isShowingAlert = false

	var noTires: Bool {
		return model.tires.isEmpty
	}

	func checkLogicalSeasonalMileageValues(with tire: TyreModel) {
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
			#warning("be careful of this logic.")
			//  Make sure the total mileage only updates
			// when additions to mileage are made.
			// also make sure value persists with change of seasonal tires.
			updateGrandTotalTyreMiles(for: currentTire, using: result)
			// save
			model.saveToMOC()
		}
	}

	func updateGrandTotalTyreMiles(for currentTire: TireEntity, using result: Double) {
		let updatedMileage = currentTire.totalTyreMyles + result
		currentTire.totalTyreMyles = updatedMileage
	}

	func delete(at index: IndexSet) {
		model.deleteTire(at: index)
	}





}
