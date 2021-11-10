//
//  DateSheetView.swift
//  Tyre Myles
//
//  Created by Daniel O'Leary on 10/19/21.
//

import SwiftUI
import CoreData

struct EditTireView: View {
	@Environment(\.dismiss) var dismiss
	@EnvironmentObject var dataModel: DataModel
	let currentTire: TireEntity

	@State private var installDate = Date()
	@State private var removalDate = Date()

	@State private var name = ""
	@State private var installMilage = ""
	@State private var removalMilage = ""
	@State private var seasonType: TireType = .allSeason


	var body: some View {
		VStack {
			TextField(currentTire.name ?? "test...", text: $name, prompt: nil)
				.textFieldStyle(.roundedBorder)
			Picker("Season", selection: $seasonType) {
				Text("Summer")
					.tag(TireType.summer)
				Text("All Season")
					.tag(TireType.allSeason)
				Text("Winter")
					.tag(TireType.winter)
			}
			.padding([.leading, .trailing])
			.pickerStyle(.segmented)

			Text("Enter Date Values")
				.font(.headline)
				.padding()
			DatePicker("Install Date", selection: $installDate, displayedComponents: .date)
			DatePicker("Removal Date", selection: $removalDate, displayedComponents: .date)

			Text("Enter Milage Values")
				.font(.headline)
				.padding()

			Group {
				TextField("Install Milage", text: $installMilage, prompt: Text("Installation Milage"))
				TextField("Removal Milage", text: $removalMilage, prompt: Text("Removal Milage"))
			}
			.keyboardType(.numberPad)
			.textFieldStyle(.roundedBorder)

			HStack {
				Button(role: .cancel) {
					dismiss()
				} label: {
					Text("Cancel")
						.foregroundColor(.red)
				}.buttonStyle(.automatic)

				Button {
					save()
					dismiss()
				} label: {
					Text("Save")
						.foregroundColor(.white)
				}.buttonStyle(.borderedProminent)
					.padding()
			}
		}
		.padding()
		.onAppear {
			loadInitialValues()
		}
	}

	private func loadInitialValues() {
		guard let loadedName = currentTire.name else { return }
		guard let loadedInstallDate = currentTire.installDate else { return }
		guard let loadedRemovalDate = currentTire.removalDate else { return }
		let loadedInstallMilage = currentTire.installMiles
		let loadedRemovalMilage = currentTire.removalMiles

		name = loadedName
		installDate = loadedInstallDate
		removalDate = loadedRemovalDate
		installMilage = String(loadedInstallMilage)
		removalMilage = String(loadedRemovalMilage)

	}

	private func save() {
		currentTire.name = name
		currentTire.seasonType = seasonType.rawValue
		currentTire.installDate = installDate
		currentTire.removalDate = removalDate
		currentTire.installMiles = Double(installMilage)!
		currentTire.removalMiles = Double(removalMilage)!

		dataModel.saveToMOC()
	}


}


struct EditTireView_Previews: PreviewProvider {
    static var previews: some View {
		VStack {
			TextField("Name", text: .constant("Name"))
				.font(.largeTitle)
			Text("Enter Date Values")
				.font(.headline)
				.padding()
			DatePicker("Install Date", selection: .constant(Date()), displayedComponents: .date)
			DatePicker("Removal Date", selection: .constant(Date()), displayedComponents: .date)

			Text("Enter Milage Values")
				.font(.headline)
				.padding()

			Group {
				TextField("Install Milage", text: .constant("100"), prompt: Text("Installation Milage"))
				TextField("Removal Milage", text: .constant("200"), prompt: Text("Removal Milage"))
			}
			.keyboardType(.numberPad)
			.textFieldStyle(.roundedBorder)

			HStack {
				Button(role: .cancel) {
					// dismiss
				} label: {
					Text("Cancel")
						.foregroundColor(.red)
				}.buttonStyle(.automatic)

				Button {
					// save the data to core Data
//					dataModel.saveTireProfileWith(name: currentTire.name!, season: season, installMiles: installMilage, removalMiles: removalMilage, installDate: installDate, removallDate: removalDate)
				} label: {
					Text("Save")
						.foregroundColor(.white)
				}.buttonStyle(.borderedProminent)
					.padding()
			}
		}
		.padding()
    }
}
