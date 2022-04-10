//
//  Tyre_MylesApp.swift
//  Tyre Myles
//
//  Created by Daniel O'Leary on 10/18/21.
//

import SwiftUI

@main
struct Tyre_MylesApp: App {
	@StateObject var savedTiresData = CoreDataModel(managedObjectContext: PersistenceController.shared.container.viewContext)
	@StateObject var tireModel = TyreViewModel()

    var body: some Scene {
		WindowGroup {
            ContentView()
				.environmentObject(savedTiresData)
				.environmentObject(tireModel)
        }
    }
}
