//
//  TireModel.swift
//  Tyre Myles
//
//  Created by Daniel O'Leary on 10/21/21.
//

import CoreData
import SwiftUI



final class DataModel: NSObject, ObservableObject, NSFetchedResultsControllerDelegate {
	@Published var savedTires: [TireEntity] = []

	let savedTireController: NSFetchedResultsController<TireEntity>

	init(managedObjectContext: NSManagedObjectContext) {
		var request: NSFetchRequest<TireEntity> {
			let fetched = NSFetchRequest<TireEntity>(entityName: "TireEntity")
			// Sorts the TireEnty by name. Change this to change sorting.
			fetched.sortDescriptors = [NSSortDescriptor(keyPath: \TireEntity.name, ascending: false)]
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

	func saveNewTireProfile(name: String, season: Season, installMiles: Double, removalMiles: Double, installDate: Date, removallDate: Date) {

		//struct TireModel {
		//
		
		//
		//	let id: UUID
		//	let name: String
		//	let season: Season
		//	let size: Int
		//	let installDate: Date
		//	let removalDate: Date
		//	let installDistance: Int
		//	let removalDistance: Int
		//	let totalDistance: Int
		//
		//}


		saveToMOC()

	}

	private func saveToMOC() {
		let moc = savedTireController.managedObjectContext

		do {
			try moc.save()
		} catch {
			print("Error in ", #function)
		}
	}

}


/*
 class DataModel: NSObject, ObservableObject, NSFetchedResultsControllerDelegate {


	** CoreData Init code **
	removed for readability.


	 // MARK: CoreData
	 func getTrainingDate() -> Date {
		 var date = Date()

		 savedRunEvents.forEach({
			 if $0.isActive {
				 guard let activeDate = $0.date else { return }
				 date = activeDate
			 }
		 })
		 return date
	 }

	 func getTrainingType() -> String {
		 var type = "5k"

		 savedRunEvents.forEach({
			 if $0.isActive {
				 guard let activeType = $0.type else { return }
				 type = activeType
			 }
		 })
		 return type
	 }

	 func getTrainingName() -> String? {
		 // Return is optional so if there is no run activated the default screen in the training view
		 // will appear on the Current Training Tab View.
		 var name: String? = nil

		 savedRunEvents.forEach({
			 if $0.isActive {
				 guard let activeName = $0.name else { return }
				 name = activeName
			 }
		 })
		 return name
	 }

	 func deleteRun(at index: IndexSet) {
		 withAnimation {
			 let moc = savedRunEventsController.managedObjectContext
			 for i in index {
				 // pull the run from the FetchRequest
				 let run = savedRunEvents[i]
				 moc.delete(run)
			 }
			 // resave to CoreData
			 saveToMOC()
		 }
	 }

	 func saveRunWith(name: String, location: String, date: Date, type: RunType) {
		 let moc = savedRunEventsController.managedObjectContext
		 if name.trimmingCharacters(in: .whitespaces) != "" {
			 let newRun = RunEvents(context: moc)
			 newRun.name = name
			 newRun.location = location
			 newRun.date = date
			 newRun.type = type.name

			 // All runs share the same progress. Without this creating a new run will reset any current training progress.
			 savedRunEvents.forEach {
				 newRun.progress = $0.progress
			 }

			 saveToMOC()
		 } else {
			 // No alert is given to the user if the save fails...
			 return
		 }
	 }

	 func saveToMOC() {
		 let moc = savedRunEventsController.managedObjectContext

		 do {
			 try moc.save()
		 } catch {
			 print("Error in ", #function)
		 }
	 }


 }
 */
