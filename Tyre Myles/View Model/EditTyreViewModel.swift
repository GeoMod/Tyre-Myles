//
//  EditTyreViewModel.swift
//  Tyre Myles
//
//  Created by Daniel O'Leary on 4/21/22.
//

import Foundation


final class EditTyreViewModel: ObservableObject {

	#warning("A dedicated VM might be ideal for editing the current tire")

	init() {
		// No current tire, so we're adding a new set.
	}

	init(currentTire: TireEntity) {
		// Passing in an existing tire set.
	}

	/*
	 private func loadInitialValues() {
		 guard let loadedName = currentTire.name else { return }
		 guard let loadedInstallDate = currentTire.installDate else { return }
		 guard let loadedRemovalDate = currentTire.removalDate else { return }
		 guard let loadedTireSeason = SeasonType(rawValue: currentTire.seasonType!) else { return }
		 let loadedInstallMilage = currentTire.installMiles
		 let loadedRemovalMilage = currentTire.removalMiles

		 name = loadedName
		 seasonType = loadedTireSeason
		 tireStatus = loadingTire(status: currentTire.isInStorage)
		 installDate = loadedInstallDate
		 removalDate = loadedRemovalDate
		 installMilage = loadedInstallMilage
		 removalMilage = loadedRemovalMilage
	 }

	 private func saveEdit() {
		 // saves to CoreData from there.
		 currentTire.name = name
		 currentTire.seasonType = seasonType.rawValue
		 currentTire.isInStorage = editingTire(status: tireStatus)
		 currentTire.installDate = installDate
		 currentTire.removalDate = removalDate
		 currentTire.installMiles = installMilage
		 currentTire.removalMiles = removalMilage

	 /// MARK: Make sure Name updates.
	 // Also doesn't include grand total in the save...

		 vm.updateCurrentTire(with: currentTire)

		 // Dismiss View
		 dismiss()
	 }
	 */
}
