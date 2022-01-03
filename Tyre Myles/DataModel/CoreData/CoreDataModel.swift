//
//  TireModel.swift
//  Tyre Myles
//
//  Created by Daniel O'Leary on 10/21/21.
//

import CoreData
import SwiftUI


//#warning("See if you can incorportate these into the ViewModel")
//enum TireType: String, CaseIterable, Identifiable {
//	// Identifiable for use in ForEach
//	var id: String { UUID().uuidString }
//
//	case summer = "Summer"
//	case allSeason = "All Season"
//	case winter = "Winter"
//}
//
//enum TireStatus {
//	case onVehicle
//	case inStorage
//}


final class DataModel: NSObject, ObservableObject, NSFetchedResultsControllerDelegate {
	@Published var savedTires: [TireEntity] = []

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
			savedTires = savedTireController.fetchedObjects ?? []
		} catch {
			print("failed to fetch items!")
		}
	}

	func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
	  guard let fetchedRunEvents = controller.fetchedObjects as? [TireEntity]
		else { return }

		savedTires = fetchedRunEvents
	}

	func saveTireProfileWith(name: String, season: TireType, status: TireStatus, installMiles: String, removalMiles: String, installDate: Date, removallDate: Date) {
		let moc = savedTireController.managedObjectContext
		let entity = TireEntity(context: moc)

		entity.name = name
		// CoreData model defines these values as Int64
		entity.installMiles = Int64(installMiles) ?? 0
		entity.removalMiles = Int64(removalMiles) ?? 0
		entity.seasonType = season.rawValue
		entity.installDate = installDate
		entity.removalDate = removallDate
		entity.id = UUID()

		switch status {
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
				let tire = savedTires[item]
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

}
