//
//  Tyre_MylesApp.swift
//  Tyre Myles
//
//  Created by Daniel O'Leary on 10/18/21.
//

import SwiftUI

@main
struct Tyre_MylesApp: App {
	@StateObject var savedTires = DataModel(managedObjectContext: PersistenceController.shared.container.viewContext)

    var body: some Scene {
        WindowGroup {
            ContentView()
				.environmentObject(savedTires)
        }
    }
}
