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


	// MARK: CoreData Model
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

	func saveToMOC() {
		let moc = savedTireController.managedObjectContext

		do {
			try moc.save()
		} catch {
			print("Error in ", #function)
		}
	}


	// MARK: ViewModel
	var noTires: Bool {
		return tires.isEmpty
	}

	func addNew(tire: TyreModel) {
		let result = tire.removalMiles - tire.installMiles

		if tire.status == .inStorage && result < 0 {
			// a negative mileage value has resulted.
			// trigger alert
			isShowingAlert = true
		} else {
			saveNew(tire: tire)
		}
	}

	#warning("Mileage computations appear to work on the Happy Path")

	func saveNew(tire: TyreModel) {
		let moc = savedTireController.managedObjectContext
		let entity = TireEntity(context: moc)

		let total = tire.removalMiles - tire.installMiles

		entity.name = tire.name
		entity.installMiles = tire.installMiles
		entity.removalMiles = tire.removalMiles
		entity.seasonType = tire.type.rawValue
		entity.installDate = tire.installDate
		entity.removalDate = tire.removalDate
		entity.totalTyreMyles = total
		entity.id = UUID()

		switch tire.status {
			case .inStorage:
				entity.isInStorage = true
			case .onVehicle:
				entity.isInStorage = false
		}
		saveToMOC()
	}

	func adjustTotalMilage(for entity: TireEntity, adding difference: Double) {
		let newGrandTotal = entity.totalTyreMyles + difference
		entity.totalTyreMyles = newGrandTotal

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

}
