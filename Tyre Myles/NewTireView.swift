//
//  NewTireView.swift
//  Tyre Myles
//
//  Created by Daniel O'Leary on 10/24/21.
//

import SwiftUI

struct NewTireView: View {

	// MARK: If new tires will not add to CoreData, try changing this to ObservedObject
	@EnvironmentObject var dataModel: DataModel

	@State private var name = ""
	@State private var season: Season = .summer
//	@State private var size = ""
//	@State private var installDate = Date()
//	@State private var removalDate = Date()
	@State private var installMiles = ""
	@State private var removalMiles = ""

	@FocusState private var isFocused: Bool

	
    var body: some View {
		NavigationView {
			VStack(alignment: .leading) {
				Text("Tire Type")
					.padding([.top, .leading])
					.font(.title2)
				Picker("Season", selection: $season) {
					Text("Summer")
						.tag(Season.summer)
					Text("Winter")
						.tag(Season.winter)
					Text("All Season")
						.tag(Season.allSeason)
				}
				.padding([.leading, .trailing])
				.pickerStyle(.segmented)

				Group {
					TextField("Tire Name", text: $name)
						.keyboardType(.alphabet)
						.padding(.top, 10)
					TextField("Install Distance", text: $installMiles)
						.keyboardType(.numberPad)
					TextField("Removal Distance", text: $removalMiles)
						.keyboardType(.numberPad)
				}
				.textFieldStyle(.roundedBorder)
				.padding([.leading, .trailing])

				Spacer()

				Button("Save") {
					let temporaryDate = Date()
					dataModel.saveNewTireProfile(name: name, season: season, installMiles: Double(installMiles) ?? 0.0, removalMiles: Double(removalMiles) ?? 0.0, installDate: temporaryDate, removallDate: temporaryDate)
				}
			}


		.navigationTitle("Add New Tire")
		}

    }


}

struct NewTireView_Previews: PreviewProvider {
	static let model = DataModel(managedObjectContext: PersistenceController.shared.container.viewContext)

    static var previews: some View {
		NewTireView()
    }
}
