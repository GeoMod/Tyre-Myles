//
//  Tyre_MylesApp.swift
//  Tyre Myles
//
//  Created by Daniel O'Leary on 10/18/21.
//

import SwiftUI

@main
struct Tyre_MylesApp: App {
	@StateObject var model = CoreDataModel(managedObjectContext: PersistenceController.shared.container.viewContext)
//	@StateObject var viewModel = TyreViewModel()

    var body: some Scene {
		WindowGroup {
            ContentView()
				.environmentObject(model)
//				.environmentObject(viewModel)
        }
    }
}
