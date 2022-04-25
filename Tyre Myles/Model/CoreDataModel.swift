//
//  TireModel.swift
//  Tyre Myles
//
//  Created by Daniel O'Leary on 10/21/21.
//

import CoreData
import SwiftUI


final class CoreDataModel: NSObject, ObservableObject, NSFetchedResultsControllerDelegate {
	@Published var tires: [TireEntity] = []
	@Published var isShowingAlert = false

	let savedTireController: NSFetchedResultsController<TireEntity>

	init(managedObjectContext: NSManagedObjectContext) {
		var request: NSFetchRequest<TireEntity> {
			let fetched = NSFetchRequest<TireEntity>(entityName: "TireEntity")
			// Sorts the TireEnty by name. Change this to change sorting.
			fetched.sortDescriptors = [NSSortDescriptor(keyPath: \TireEntity.installDate, ascending: false)]
			return fetched
		}
		savedTireController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
		savedTireController.managedObjectContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
		savedTireController.managedObjectContext.automaticallyMergesChangesFromParent = true

		super.init()

		savedTireController.delegate = self

		do {
			try savedTireController.performFetch()
			tires = savedTireController.fetchedObjects ?? []
		} catch {
			print("failed to fetch items!")
		}
	}

	func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
	  guard let fetchedTires = controller.fetchedObjects as? [TireEntity]
		else { return }

		tires = fetchedTires
	}

	func saveTireProfileWith(tire: TyreModel) {
		let moc = savedTireController.managedObjectContext
		let entity = TireEntity(context: moc)

		entity.name = tire.name
		entity.installMiles = tire.installMiles
		entity.removalMiles = tire.removalMiles
		entity.seasonType = tire.type.rawValue
		entity.installDate = tire.installDate
		entity.removalDate = tire.removalDate
		entity.id = UUID()

		switch tire.status {
			case .inStorage:
				entity.isInStorage = true
			case .onVehicle:
				entity.isInStorage = false
		}
		saveToMOC()
	}

	func deleteTire(at index: IndexSet) {
		withAnimation {
			let moc = savedTireController.managedObjectContext
			index.forEach { item in
				let tire = tires[item]
				moc.delete(tire)
			}
		}
		// resave to CoreData
		saveToMOC()
	}

	func saveToMOC() {
		let moc = savedTireController.managedObjectContext

		do {
			try moc.save()
		} catch {
			print("Error in ", #function)
		}
	}

	// can be used in place of DispatchQueue.main.async

	/*
	 extension MainActor {
		 /// Execute the given body closure on the main actor.
		 public static func run<T>(resultType: T.Type = T.self, body: @MainActor @Sendable () throws -> T) async rethrows -> T
	 }

	 Usage:
	 async {
		 await MainActor.run {
			 // Perform UI updates
		 }
	 }
	 */

	var noTires: Bool {
		return tires.isEmpty
	}

	func checkLogicalSeasonalMileageValues(with tire: TyreModel) {
		let result = tire.removalMiles - tire.installMiles

		if tire.status == .inStorage && result <= 0 {
			// a negative or 0 mileage value has resulted.
			// trigger alert
			isShowingAlert = true
		} else {
			saveTireProfileWith(tire: tire)
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
			saveToMOC()
		}
	}

	func updateGrandTotalTyreMiles(for currentTire: TireEntity, using result: Double) {
		let updatedMileage = currentTire.totalTyreMyles + result
		currentTire.totalTyreMyles = updatedMileage
	}

}
