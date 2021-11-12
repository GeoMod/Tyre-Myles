//
//  ContentView.swift
//  Tyre Myles
//
//  Created by Daniel O'Leary on 10/18/21.
//

import SwiftUI
import CoreData


struct ContentView: View {
	@Environment(\.colorScheme) var colorScheme
	@EnvironmentObject var dataModel: DataModel

	@State private var selectedTireSeason: TireType = .allSeason


	var body: some View {

		NavigationView {
			VStack {
				List {
					ForEach(dataModel.savedTires, id: \.id) { tire in
						Section(header: Text(tire.seasonType!)
									.font(.largeTitle.bold())
									.foregroundColor(.gray)
						) {
							VStack {
								Text(tire.name!)
									.font(Font.title2.bold())
								DateMilageView(currentTire: tire)
							}
						}.headerProminence(.increased)
					}.onDelete { index in
						dataModel.deleteTire(at: index)
					}
				}.listStyle(.insetGrouped)
			}
			.navigationTitle("My Tyre Myles")

			.toolbar {
				ToolbarItem(placement: .navigationBarLeading) { EditButton() }
				ToolbarItem(placement: .navigationBarTrailing) {
					NavigationLink {
						AddTireView()
					} label: {
						Image(systemName: "plus.circle")
							.font(.title2.bold())
					}
				}
			}

		}
	}

	
}


//struct ContentView_Previews: PreviewProvider {
////	static let model = DataModel(managedObjectContext: PersistenceController.shared.container.viewContext)
//    static var previews: some View {
//		Text("Hello World")
//	}
//
//}
