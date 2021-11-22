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
	@State private var tireStatus: TireStatus = .inStorage


	var body: some View {
		VStack {
			Text("Edit Tyre")
				.font(.largeTitle)
			TextField(currentTire.name ?? "Name", text: $name, prompt: nil)
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

			Picker("Wheel Status", selection: $tireStatus) {
				Text("In Storage").tag(TireStatus.inStorage)
				Text("On Vehicle").tag(TireStatus.onVehicle)
			}.pickerStyle(.segmented)
				.padding(.vertical)

			DatePicker("Removal Date", selection: $removalDate, displayedComponents: .date)
				.disabled(tireStatus == .onVehicle)

			Text("Enter Mileage Values")
				.font(.headline)
				.padding()

			Group {
				TextField("Install Mileage", text: $installMilage, prompt: Text("Installation Mileage"))
				TextField("Removal Mileage", text: $removalMilage, prompt: Text("Removal Mileage"))
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
		guard let loadedTireSeason = currentTire.seasonType else { return }
		let loadedTireStatus = currentTire.isInStorage
		let loadedInstallMilage = currentTire.installMiles
		let loadedRemovalMilage = currentTire.removalMiles

		name = loadedName
		seasonType = checkTireSeason(type: loadedTireSeason)
		tireStatus = loadTireLocation(status: loadedTireStatus)
		installDate = loadedInstallDate
		removalDate = loadedRemovalDate
		installMilage = String(loadedInstallMilage)
		removalMilage = String(loadedRemovalMilage)

	}

	// Takes the enum used to create the tire when it was initially saved, and works it backwards.
	private func checkTireSeason(type: String) -> TireType {
		switch type {
			case "Summer":
				return .summer
			case "All Season":
				return .allSeason
			case "Winter":
				return .winter
			default:
				return .allSeason
		}
	}

	private func loadTireLocation(status: Bool) -> TireStatus {
		// To set value of Picker when loading this Edit View.
		switch status {
			case true:
				return .inStorage
			case false:
				return .onVehicle
		}
	}

	private func saveTireLocation(status: TireStatus) -> Bool {
		// To save the proper boolean value to CoreData
		switch status {
			case .onVehicle:
				return false
			case .inStorage:
				return true
		}
	}


	private func save() {
		currentTire.name = name
		currentTire.seasonType = seasonType.rawValue
		currentTire.isInStorage = saveTireLocation(status: tireStatus)
		currentTire.installDate = installDate
		currentTire.removalDate = removalDate
		currentTire.installMiles = Double(installMilage) ?? 0
		currentTire.removalMiles = Double(removalMilage) ?? 0

		dataModel.saveToMOC()
	}


}

#if DEBUG
struct EditTireView_Previews: PreviewProvider {
    static var previews: some View {
		Text("Test View")
    }
}
#endif
