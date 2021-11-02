//
//  NewTireView.swift
//  Tyre Myles
//
//  Created by Daniel O'Leary on 10/24/21.
//

import SwiftUI

struct AddTireView: View {
	@Environment(\.dismiss) var dismiss

	// MARK: If new tires will not add to CoreData, try changing this to ObservedObject
	@EnvironmentObject var dataModel: DataModel

	@State private var name = ""
	@State private var season: Season = .summer
	@State private var installDate = Date()
	@State private var removalDate = Date()
	@State private var installMiles = ""
	@State private var removalMiles = ""

//	@FocusState private var isFocused: Bool

	
	var body: some View {
		VStack {
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

			Group {
				Text("Enter Date Values")
					.font(.title2)
					.padding(.top, 40)
				DatePicker("Install Date", selection: $installDate, displayedComponents: .date)
				DatePicker("Removal Date", selection: $removalDate, displayedComponents: .date)
			}.padding([.leading, .trailing])

			Spacer()

			Button {
				save()
			} label: {
				Capsule()
					.frame(height: 50)
					.overlay(Text("Save")
								.font(.title2.bold())
								.foregroundColor(.white)
					)
			}.foregroundStyle(LinearGradient(colors: [.purple, .blue], startPoint: .top, endPoint: .bottom))
				.padding()

		}
		.navigationTitle("Add New Tire")
		.toolbar {
			ToolbarItem(placement: .cancellationAction) {
				Button("Cancel", role: .cancel) {
					cancel()
				}
			}
		}


	}

	private func save() {
		dataModel.saveTireProfileWith(name: name, season: season, installMiles: installMiles, removalMiles: removalMiles, installDate: installDate, removallDate: removalDate)
		dismiss()
	}

	private func cancel() {
		dismiss()
	}

}

struct NewTireView_Previews: PreviewProvider {
	static let model = DataModel(managedObjectContext: PersistenceController.shared.container.viewContext)

    static var previews: some View {
		AddTireView()
    }
}